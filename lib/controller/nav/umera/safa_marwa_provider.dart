import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:umrati/controller/nav/umera/tawaf_provider.dart';

import '../../../utils/helper/constants.dart';
import '../../../utils/services/toast.dart';
import '../../../widgets/tawaf_completed_dialog.dart';

// Provider for SafaMarwaNotifier using ChangeNotifier
final safaMarwaProvider = ChangeNotifierProvider<SafaMarwaNotifier>((ref) => SafaMarwaNotifier());

class SafaMarwaNotifier extends ChangeNotifier {
  // Context for showing dialogs and other UI operations
  BuildContext? context;
  // Reference for accessing other providers
  WidgetRef? ref;
  // Controller for scrolling animation during Safa-Marwa run
  ScrollController? scrollController;
  // Percentage completion of one side of Safa-Marwa run (0.0 to 1.0)
  double oneSideRunCompletionPercent = 0.0;
  // Flag to track if one side of the run is complete
  bool isRunComplete = false;
  // Counter for completed rounds between Safa and Marwa
  int circleCount = 0;

  // Initialization method to request location permissions
  initialization() async {
    await _getPermission();
  }

  // Method to request location permissions and setup location tracking
  Future<void> _getPermission() async {
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Get Safa coordinates from Firestore
      var safaDoc = await settingsCollection.doc(CommonDoc.safa.name).get();
      var safaLatLng = LatLng(safaDoc.data()!['lat'], safaDoc.data()!['lng']);
      // Get Marwa coordinates from Firestore
      var marwaDoc = await settingsCollection.doc(CommonDoc.marwa.name).get();
      var marwaLatLng = LatLng(marwaDoc.data()!['lat'], marwaDoc.data()!['lng']);
      // Get threshold distance for considering arrival at Safa/Marwa
      var safaMarwaThreshold = (await settingsCollection.doc(CommonDoc.safaMarwaThreshold.name).get()).data()!['value'];
      // Calculate total distance between Safa and Marwa
      var safaMarwaDistance = Geolocator.distanceBetween(safaLatLng.latitude, safaLatLng.longitude, marwaLatLng.latitude, marwaLatLng.longitude);
      // Start listening to position updates
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
      ).listen((position) => _updateLocation(position, safaLatLng, marwaLatLng, safaMarwaDistance, safaMarwaThreshold));
    } else {
      // Show error if location permission is denied
      errorToast('Please allow location permission');
      notifyListeners();
    }
  }

  // Method to update location and track progress between Safa and Marwa
  void _updateLocation(Position position, LatLng safaLatLng, LatLng marwaLatLng, double safaMarwaDistance, double threshold) {
    if (isRunComplete) {
      // If coming back from Marwa to Safa
      var distance = Geolocator.distanceBetween(position.latitude, position.longitude, safaLatLng.latitude, safaLatLng.longitude);
      if (distance < threshold) {
        // Reached Safa - update circle count
        _updateCircleCount();
      } else {
        // Update completion percentage
        oneSideRunCompletionPercent = roundToOneDecimal(distance / safaMarwaDistance);
      }
    } else {
      // If going from Safa to Marwa
      var distance = Geolocator.distanceBetween(position.latitude, position.longitude, marwaLatLng.latitude, marwaLatLng.longitude);
      if (distance < threshold) {
        // Reached Marwa
        isRunComplete = true;
      } else {
        // Update completion percentage
        oneSideRunCompletionPercent = roundToOneDecimal(distance / safaMarwaDistance);
      }
    }
    notifyListeners();
    // Animate scroll position based on completion percentage
    if (scrollController!.hasClients) {
      var position = scrollController!.position.maxScrollExtent * (1 - oneSideRunCompletionPercent);
      scrollController!.animateTo(position, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
    }
  }

  // Method to update circle count when a round is completed
  _updateCircleCount() {
    positionStreamSubscription?.cancel();
    circleCount++;
    if (circleCount == 7) {
      // All 7 rounds completed - show completion dialog
      tawafCompletionDialog();
    }
    isRunComplete = false;
  }

  // Method to reset all tracking variables
  _resetSafaMarwa() {
    circleCount = 0;
    oneSideRunCompletionPercent = 0.0;
    isRunComplete = false;
    notifyListeners();
  }

  // Method to show completion dialog and reset state
  tawafCompletionDialog() async {
    await showGeneralDialog(context: context!, pageBuilder: (context, animation, secondaryAnimation) => TawafCompletionDialog());
    _resetSafaMarwa();
    // Notify tawaf provider about completion
    ref?.watch(tawafProvider).safaMarwaCompleted();
  }

  @override
  void dispose() {
    // Cancel position updates when notifier is disposed
    positionStreamSubscription?.cancel();
    super.dispose();
  }
}
