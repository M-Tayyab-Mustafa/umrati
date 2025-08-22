import 'package:latlong2/latlong.dart';
import '../../../export.dart' hide LatLng;

// Provider for SafaMarwaNotifier using ChangeNotifier
final safaMarwaProvider = ChangeNotifierProvider.autoDispose<SafaMarwaNotifier>((ref) => SafaMarwaNotifier());

class SafaMarwaNotifier extends ChangeNotifier {
  WidgetRef? _ref;
  BuildContext? _context;

  WidgetRef get ref => _ref!;
  BuildContext get context => _context!;

  StreamSubscription<Position>? positionStreamSubscription;

  // Controller for scrolling animation during Safa-Marwa run
  ScrollController? scrollController;

  // Percentage completion of one side of Safa-Marwa run (0.0 to 1.0)
  double oneSideRunCompletionPercent = 0.0;

  // Flag to track if one side of the run is complete
  bool isRunComplete = false;

  // Counter for completed rounds between Safa and Marwa
  int saiRoundCount = 0;

  // Initialization method to request location permissions
  initialization(WidgetRef ref, BuildContext context) async {
    _ref = ref;
    _context = context;
    _cancelPositionStreamSubscription();
    isRunComplete = ref.read(tawafProvider).user!.isOneSideSaiRunCompleted;
    saiRoundCount = ref.read(tawafProvider).user!.saiRoundCount;
    notifyListeners();

    var safaMarwaModel = SafaMarwaModel.fromMap((await settingsCollection.doc(CommonDoc.safaMarwa.name).get()).data()!);
    var safaLatLng = LatLng(double.parse(safaMarwaModel.safaLat), double.parse(safaMarwaModel.safaLng));
    var marwaLatLng = LatLng(double.parse(safaMarwaModel.marwaLat), double.parse(safaMarwaModel.marwaLng));
    var safaMarwaDistance = num.parse(safaMarwaModel.distance);
    var threshold = num.parse(safaMarwaModel.threshold);
    try {
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
      ).listen((position) => _updateLocation(position, safaLatLng, marwaLatLng, safaMarwaDistance, threshold));
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  // Method to update location and track progress between Safa and Marwa
  void _updateLocation(Position position, LatLng safaLatLng, LatLng marwaLatLng, num safaMarwaDistance, num threshold) {
    if (!ref.read(tawafProvider).isInTawaf) {
      _cancelPositionStreamSubscription();
      return;
    }

    if (isRunComplete) {
      var safaDistance = Geolocator.distanceBetween(position.latitude, position.longitude, safaLatLng.latitude, safaLatLng.longitude).abs();
      if (safaDistance > (safaMarwaDistance + threshold)) return;
      if (safaDistance <= threshold) {
        _updateRoundCount();
      } else {
        oneSideRunCompletionPercent = (safaDistance / safaMarwaDistance).clamp(0, 1);
      }
    } else {
      var marwaDistance = Geolocator.distanceBetween(position.latitude, position.longitude, marwaLatLng.latitude, marwaLatLng.longitude).abs();
      if (marwaDistance <= threshold) {
        LocalStorageManager.saveUser(ref.read(tawafProvider).user!.copyWith(isOneSideSaiRunCompleted: true));
        isRunComplete = true;
      } else {
        if (marwaDistance > (safaMarwaDistance + threshold)) return;
        oneSideRunCompletionPercent = (marwaDistance / safaMarwaDistance).clamp(0, 1);
      }
    }
    notifyListeners();
    if (scrollController!.hasClients) {
      var position = scrollController!.position.maxScrollExtent * (1 - oneSideRunCompletionPercent);
      scrollController!.animateTo(position, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
    }
  }

  _updateRoundCount() async {
    isRunComplete = false;
    saiRoundCount++;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);
    }
    oneSideRunCompletionPercent = 0.0;
    notifyListeners();
    LocalStorageManager.saveUser(ref.read(tawafProvider).user!.copyWith(saiRoundCount: saiRoundCount, isOneSideSaiRunCompleted: false));
    if (saiRoundCount == 7) {
      _cancelPositionStreamSubscription();
      saiRoundCount = 0;
      notifyListeners();
      await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => TawafCompletionDialog());
      ref.read(tawafProvider).isSafaMarwaCompleted();
    }
  }

  _cancelPositionStreamSubscription() {
    positionStreamSubscription?.cancel();
    positionStreamSubscription = null;
  }

  @override
  void dispose() {
    _cancelPositionStreamSubscription();
    super.dispose();
  }
}
