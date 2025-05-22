import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../model/safa_marwa.dart';
import '../../../utils/helper/constants.dart';
import '../../../utils/services/toast.dart';
import '../../../widgets/tawaf_completed_dialog.dart';
import 'tawaf_provider.dart';

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
  int circleCount = kDebugMode ? 6 : 0;

  // Initialization method to request location permissions
  initialization() async {
    notifyListeners();
    if (kDebugMode) {
      _updateCircleCount();
    }
    await _getPermission();
  }

  // Method to request location permissions and setup location tracking
  Future<void> _getPermission() async {
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Get threshold distance for considering arrival at Safa/Marwa
      SafaMarwaModel safaMarwa = SafaMarwaModel.fromMap((await settingsCollection.doc(CommonDoc.safaMarwa.name).get()).data()!);
      // Start listening to position updates
      positionStreamSubscription = Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.best)).listen(
        (position) => _updateLocation(
          position,
          LatLng(double.parse(safaMarwa.safaLat), double.parse(safaMarwa.safaLng)),
          LatLng(double.parse(safaMarwa.marwaLat), double.parse(safaMarwa.marwaLng)),
          num.parse(safaMarwa.distance),
          num.parse(safaMarwa.threshold),
        ),
      );
    } else {
      // Show error if location permission is denied
      errorToast('Please allow location permission');
      notifyListeners();
    }
  }

  // Method to update location and track progress between Safa and Marwa
  void _updateLocation(Position position, LatLng safaLatLng, LatLng marwaLatLng, num safaMarwaDistance, num threshold) {
    if (isRunComplete) {
      var distance = (safaMarwaDistance - Geolocator.distanceBetween(position.latitude, position.longitude, safaLatLng.latitude, safaLatLng.longitude)).abs();
      if (distance <= threshold) {
        _updateCircleCount();
      } else {
        oneSideRunCompletionPercent = (distance / safaMarwaDistance);
      }
    } else {
      var distance = (safaMarwaDistance - Geolocator.distanceBetween(position.latitude, position.longitude, marwaLatLng.latitude, marwaLatLng.longitude)).abs();
      if (distance <= threshold) {
        isRunComplete = true;
      } else {
        oneSideRunCompletionPercent = (distance / safaMarwaDistance);
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
    ref?.read(tawafProvider).isSafaMarwaCompleted();
  }

  @override
  void dispose() {
    // Cancel position updates when notifier is disposed
    positionStreamSubscription?.cancel();
    super.dispose();
  }
}
