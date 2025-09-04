import 'package:latlong2/latlong.dart';
import '../../../export.dart' hide LatLng;

// Provider for SafaMarwaNotifier using ChangeNotifier
final safaMarwaProvider = ChangeNotifierProvider.autoDispose<SafaMarwaNotifier>((ref) => SafaMarwaNotifier());

class SafaMarwaNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  late HistoryModel umraModel;
  StreamSubscription<Position>? positionStreamSubscription;
  ScrollController scrollController = ScrollController();
  double oneSideRunCompletionPercent = 0.0;
  bool isRunComplete = false;
  int saiRoundCount = 0;

  Future<void> initialization() async {
    umraModel = ref.read(umraProvider.notifier).umraModel!;
    isRunComplete = umraModel.is_one_side_sai_run_completed;
    saiRoundCount = umraModel.sai_round_count;
    notifyListeners();
    _cancelPositionStreamSubscription();
    final safaMarwaModel = SafaMarwaModel.fromMap((await settingsCollection.doc(CommonDoc.safaMarwa.name).get()).data()!);
    final safaLatLng = LatLng(double.parse(safaMarwaModel.safaLat), double.parse(safaMarwaModel.safaLng));
    final marwaLatLng = LatLng(double.parse(safaMarwaModel.marwaLat), double.parse(safaMarwaModel.marwaLng));
    final safaMarwaDistance = num.parse(safaMarwaModel.distance);
    final threshold = num.parse(safaMarwaModel.threshold);
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
    if (!umraModel.is_doing) return _cancelPositionStreamSubscription();
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
        umraModel = umraModel.copyWith(is_one_side_sai_run_completed: true);
        ref.read(umraProvider.notifier).updateUmraModel(umraModel);
        isRunComplete = true;
      } else {
        if (marwaDistance > (safaMarwaDistance + threshold)) return;
        oneSideRunCompletionPercent = (marwaDistance / safaMarwaDistance).clamp(0, 1);
      }
    }
    notifyListeners();
    if (scrollController.hasClients) {
      var position = scrollController.position.maxScrollExtent * (1 - oneSideRunCompletionPercent);
      scrollController.animateTo(position, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
    }
  }

  _updateRoundCount() async {
    isRunComplete = false;
    saiRoundCount++;
    if (await Vibration.hasVibrator()) Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);
    oneSideRunCompletionPercent = 0.0;
    notifyListeners();
    umraModel = umraModel.copyWith(sai_round_count: saiRoundCount, is_one_side_sai_run_completed: false);
    ref.read(umraProvider.notifier).updateUmraModel(umraModel);
    if (saiRoundCount == 7) {
      _cancelPositionStreamSubscription();
      saiRoundCount = 0;
      notifyListeners();
      await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => TawafCompletionDialog());
      ref.read(umraProvider).safaMarwaCompleted();
    }
  }

  void _cancelPositionStreamSubscription() {
    positionStreamSubscription?.cancel();
    positionStreamSubscription = null;
  }

  @override
  void dispose() {
    _cancelPositionStreamSubscription();
    scrollController.dispose();
    super.dispose();
  }
}
