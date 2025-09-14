import '../../../export.dart';
import '../../../widgets/dialog/safa_marwa_start_confirmation.dart';

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

  double distanceBetweenSafaAndMarwa = 0;
  Alignment startingRunAlign = Alignment(0, 0.34);
  Alignment endingRunAlign = Alignment(0, -0.34);

  Future<void> initialization() async {
    umraModel = ref.read(umraProvider.notifier).umraModel!;
    isRunComplete = umraModel.is_one_side_sai_run_completed;
    saiRoundCount = umraModel.sai_round_count;
    _updateRunLocations();
    _cancelPositionStreamSubscription();
    final safaMarwaModel = SafaMarwaModel.fromMap((await settingsCollection.doc(CommonDoc.safaMarwa.name).get()).data()!);
    final safaLatLng = LatLng(safaMarwaModel.safaLat, safaMarwaModel.safaLng);
    final marwaLatLng = LatLng(safaMarwaModel.marwaLat, safaMarwaModel.marwaLng);
    final safaMarwaDistance = num.parse(safaMarwaModel.distance);
    final threshold = num.parse(safaMarwaModel.threshold);
    distanceBetweenSafaAndMarwa = Geolocator.distanceBetween(safaLatLng.latitude, safaLatLng.longitude, marwaLatLng.latitude, marwaLatLng.longitude);
    try {
      var currentPosition = await Geolocator.getCurrentPosition();
      var distanceFromSafa = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, safaLatLng.latitude, safaLatLng.longitude).abs();
      if (!context.mounted) return;
      if (!(distanceFromSafa <= threshold)) await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => SafaMarwaStartConfirmationDialog());
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
      ).listen((position) => _updateLocation(position, safaLatLng, marwaLatLng, safaMarwaDistance, threshold));
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  // Method to update location and track progress between Safa and Marwa
  void _updateLocation(Position position, LatLng safaLatLng, LatLng marwaLatLng, num safaMarwaDistance, num threshold) async {
    if (!umraModel.is_doing) return _cancelPositionStreamSubscription();
    if (isRunComplete) {
      var safaDistance = Geolocator.distanceBetween(position.latitude, position.longitude, safaLatLng.latitude, safaLatLng.longitude).abs();
      if (safaDistance > (safaMarwaDistance + threshold)) return;
      if (safaDistance <= threshold) {
        await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => TawafCompletionDialog());
        await _updateRoundCount();
        _updateRunLocations();
      } else {
        oneSideRunCompletionPercent = (safaDistance / safaMarwaDistance).clamp(0, 1);
      }
    } else {
      var marwaDistance = Geolocator.distanceBetween(position.latitude, position.longitude, marwaLatLng.latitude, marwaLatLng.longitude).abs();
      if (marwaDistance <= threshold) {
        umraModel = umraModel.copyWith(is_one_side_sai_run_completed: true);
        await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => TawafCompletionDialog());
        ref.read(umraProvider.notifier).updateUmraModel(umraModel);
        isRunComplete = true;
        _updateRunLocations();
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

  Future<void> _updateRoundCount() async {
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
      ref.read(umraProvider).safaMarwaCompleted();
    }
  }

  void _updateRunLocations() {
    if (isRunComplete) {
      endingRunAlign = Alignment(0, 0.34);
      startingRunAlign = Alignment(0, -0.34);
    } else {
      startingRunAlign = Alignment(0, 0.34);
      endingRunAlign = Alignment(0, -0.34);
    }
    notifyListeners();
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
