import 'dart:async' show Timer;
import 'dart:math' hide log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:umrati/utils/services/local_storage.dart';
import '../../../model/user.dart';
import '../../../utils/helper/constants.dart';
import '../../../utils/services/toast.dart';
import '../../../widgets/dialog/already_in_umera.dart';
part '../../../utils/helper/tawaf.dart';

// Provider for TawafNotifier using ChangeNotifier
final tawafProvider = ChangeNotifierProvider<TawafNotifier>((ref) => TawafNotifier());

class TawafNotifier extends ChangeNotifier {
  bool isLoading = false;

  // Flag to track if user is currently performing Tawaf
  bool isInTawaf = false;
  UserModel? user;

  // Flags for Tawaf requirements
  bool isPerformed2RakatsSalah = false;
  bool isDrinkZamzam = false;

  // Tawaf round tracking
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = false;
  int circleCount = kDebugMode ? 6 : 0; // Total rounds required for Tawaf

  // Completion flags for different stages
  bool showSafaMarwa = false;
  bool isSafaMarwaComplete = false;

  //* Umera Complete
  bool isUmeraCompleted = false;
  bool isShavedHead = false;

  // Initialize TawafNotifier
  initialization(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    user = UserModel.fromMap((await userCollection.doc(((await LocalStorageManager.getUser())!.uid)).get()).data() as Map<String, dynamic>);
    if (user?.is_tawaf_completed == true) {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlreadyInUmeraDialog());
      if (result == true) {
        isInTawaf = true;
        showSafaMarwa = true;
      } else {
        updateUserOnFirebase(user!.copyWith(is_tawaf_completed: false));
      }
    }
    isLoading = false;
    notifyListeners();
  }

  updateUserOnFirebase(UserModel user) async {
    this.user = user;
    notifyListeners();
    await userCollection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  // Method to start or stop Tawaf
  startTawaf() async {
    if (isInTawaf) {
      isInTawaf = false;
      showSafaMarwa = false;
      isSafaMarwaComplete = false;
      updateUserOnFirebase(user!.copyWith(is_tawaf_completed: false));
      positionStreamSubscription?.cancel();
      _resetTawaf();
      return;
    }
    // Start Tawaf
    isInTawaf = true;
    notifyListeners();
    if (kDebugMode) {
      _updateCircleTemp();
    } else {
      _getPermission();
    }
  }

  _updateCircleTemp() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (circleCount >= 7) {
        updateUserOnFirebase(user!.copyWith(is_tawaf_completed: true));
      } else {
        if (tawafCircleCompletionPercent >= 0.9) {
          isRoundCompleted = true;
          circleCount++;
          timer.cancel();
        } else {
          tawafCircleCompletionPercent = tawafCircleCompletionPercent + 0.1;
        }
        notifyListeners();
      }
    });
  }

  // Method to request location permissions and initialize Tawaf
  Future<void> _getPermission() async {
    // Reset tracking variables
    tawafCircleCompletionPercent = 0;
    notifyListeners();

    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Get current position and Kaaba coordinates
      var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      var alKabaLatLongDoc = await settingsCollection.doc(CommonDoc.alKaba.name).get();
      var kabaLatLng = LatLng(alKabaLatLongDoc.data()!['lat'], alKabaLatLongDoc.data()!['lng']);

      // Start listening to position updates
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 1),
      ).listen((position) => _updateLocation(position, currentPosition, kabaLatLng));
    } else {
      errorToast('Please allow location permission');
      _resetTawaf();
    }
  }

  // Method to update location and track Tawaf progress
  Future<void> _updateLocation(Position currentPosition, Position startingPosition, LatLng kabaLatLng) async {
    if (circleCount >= 7) {
      positionStreamSubscription?.cancel();
      updateUserOnFirebase(user!.copyWith(is_tawaf_completed: true));
    }
    final currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    final startingLatLng = LatLng(startingPosition.latitude, startingPosition.longitude);

    // Calculate bearings from Kaaba to starting and current positions
    double startBearing = calculateBearing(kabaLatLng, startingLatLng);
    double currentBearing = calculateBearing(kabaLatLng, currentLatLng);

    // Calculate progress angle in anti-clockwise direction
    double progressAngle = antiClockwiseDelta(startBearing, currentBearing);

    if (progressAngle > 0) {
      // Update completion percentage (0.0 to 1.0)
      tawafCircleCompletionPercent = (progressAngle / 360).clamp(0.0, 1.0);

      // Check if round is completed (360 degrees)
      if (progressAngle >= 360) {
        isRoundCompleted = true;
        circleCount++;
        positionStreamSubscription?.cancel();
      }
    }
    notifyListeners();
  }

  // Method to start the next Tawaf round
  startNextRound() {
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
    if (kDebugMode) {
      _updateCircleTemp();
    } else {
      _getPermission();
    }
    notifyListeners();
  }

  // Method to reset Tawaf tracking variables
  _resetTawaf() {
    circleCount = 0;
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
    notifyListeners();
  }

  // Method to move to Safa-Marwa after completing Tawaf
  moveToSafaMarwa({required BuildContext context, required WidgetRef ref}) {
    // Check if requirements are met
    if (isPerformed2RakatsSalah == false || isDrinkZamzam == false) {
      errorToast('Please perform 2 rakats salah, and drink Zamzam');
      return;
    }
    isSafaMarwaComplete = false;
    showSafaMarwa = true;
    _resetTawaf();
  }

  // Method to toggle 2 Rakats Salah completion
  void perform2RakatsSalah() {
    isPerformed2RakatsSalah = !isPerformed2RakatsSalah;
    notifyListeners();
  }

  // Method to toggle Zamzam drinking completion
  void drinkZamzam() {
    isDrinkZamzam = !isDrinkZamzam;
    notifyListeners();
  }

  // Method to mark Umra as completed
  void umeraCompleted() {
    isUmeraCompleted = true;
    notifyListeners();
  }

  // Method to return to home state
  void goToHome() {
    isInTawaf = false;
    showSafaMarwa = false;
    isUmeraCompleted = false;
    isSafaMarwaComplete = false;
    notifyListeners();
  }

  // Helper method to calculate anti-clockwise angle difference
  double antiClockwiseDelta(double from, double to) {
    double delta = from - to;
    if (delta < 0) delta += 360;
    return delta;
  }

  void toggleShaveTheHead() {
    isShavedHead = !isShavedHead;
    notifyListeners();
  }

  @override
  void dispose() {
    // Cancel position updates when notifier is disposed
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  void isSafaMarwaCompleted() {
    isSafaMarwaComplete = true;
    updateUserOnFirebase(user!.copyWith(is_tawaf_completed: false));
    notifyListeners();
  }
}
