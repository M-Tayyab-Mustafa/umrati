import '../../../../export.dart';

// Provider for SafaMarwaNotifier using ChangeNotifier
final safaMarwaProvider = ChangeNotifierProvider.autoDispose<SafaMarwaNotifier>((ref) => SafaMarwaNotifier());

class SafaMarwaNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  late HistoryModel umrahModel;
  StreamSubscription<Position>? positionStreamSubscription;
  ScrollController scrollController = ScrollController();
  double oneSideRunCompletionPercent = 0.0;
  bool isOneSideSaiRunCompleted = false;
  int saiRoundCount = 0;

  double distanceBetweenSafaAndMarwa = 0;
  SafaMarwaModel? safaMarwaModel;

  Future<void> initialization() async {
    umrahModel = ref.read(umrahProvider.notifier).umrahModel!;
    isOneSideSaiRunCompleted = umrahModel.is_one_side_sai_run_completed;
    saiRoundCount = umrahModel.sai_round_count;
    cancelPositionStreamSubscription();
    safaMarwaModel = SafaMarwaModel.fromMap((await settingsCollection.doc(CommonDoc.safaMarwa.name).get()).data()!);
    final safaLatLng = LatLng(safaMarwaModel!.safaLat, safaMarwaModel!.safaLng);
    final marwaLatLng = LatLng(safaMarwaModel!.marwaLat, safaMarwaModel!.marwaLng);
    distanceBetweenSafaAndMarwa = Geolocator.distanceBetween(safaLatLng.latitude, safaLatLng.longitude, marwaLatLng.latitude, marwaLatLng.longitude);
    try {
      var currentPosition = await Geolocator.getCurrentPosition();
      var distanceFromSafa = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, safaLatLng.latitude, safaLatLng.longitude).abs();
      if (!context.mounted) return;
      if (!(distanceFromSafa <= num.parse(safaMarwaModel!.threshold))) {
        await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => StartConfirmationDialog(fromUmrah: false));
      }
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
    try {
      await initializeSafaMarwaLocationTracking();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  Future<void> initializeSafaMarwaLocationTracking() async {
    final safaLatLng = LatLng(safaMarwaModel!.safaLat, safaMarwaModel!.safaLng);
    final marwaLatLng = LatLng(safaMarwaModel!.marwaLat, safaMarwaModel!.marwaLng);
    final safaMarwaDistance = num.parse(safaMarwaModel!.distance);
    var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
    _updateLocation(currentPosition, safaLatLng, marwaLatLng, safaMarwaDistance, num.parse(safaMarwaModel!.threshold));
    positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
    ).listen((position) => _updateLocation(position, safaLatLng, marwaLatLng, safaMarwaDistance, num.parse(safaMarwaModel!.threshold)));
  }

  // Method to update location and track progress between Safa and Marwa
  void _updateLocation(Position position, LatLng safaLatLng, LatLng marwaLatLng, num safaMarwaDistance, num threshold) async {
    if (!umrahModel.is_doing) return cancelPositionStreamSubscription();
    if (isOneSideSaiRunCompleted) {
      var safaDistance = Geolocator.distanceBetween(position.latitude, position.longitude, safaLatLng.latitude, safaLatLng.longitude).abs();
      if (safaDistance > (safaMarwaDistance + threshold)) return;
      if (safaDistance <= threshold) {
        await _updateRoundCount();
      } else {
        oneSideRunCompletionPercent = (safaDistance / safaMarwaDistance).clamp(0, 1);
      }
    } else {
      var marwaDistance = Geolocator.distanceBetween(position.latitude, position.longitude, marwaLatLng.latitude, marwaLatLng.longitude).abs();
      if (marwaDistance <= threshold) {
        isOneSideSaiRunCompleted = true;
        await _updateRoundCount();
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
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.now_please_pray_while_facing_kibla.tr(), withContinueButton: true),
    );
    saiRoundCount++;
    if (await Vibration.hasVibrator()) Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);
    if (isOneSideSaiRunCompleted) {
      oneSideRunCompletionPercent = 1.0;
    } else {
      oneSideRunCompletionPercent = 0.0;
    }
    notifyListeners();
    umrahModel = umrahModel.copyWith(sai_round_count: saiRoundCount, is_one_side_sai_run_completed: isOneSideSaiRunCompleted);
    ref.read(umrahProvider.notifier).updateUmraModel(umrahModel);
    if (saiRoundCount == 7) {
      cancelPositionStreamSubscription();
      saiRoundCount = 0;
      notifyListeners();
      ref.read(umrahProvider).safaMarwaCompleted();
    }
  }

  //Todo:: Remove After Testing...
  void debugSkipSafaMarwa() async {
    if (umrahModel.is_one_side_sai_run_completed) {
      isOneSideSaiRunCompleted = false;
      await _updateRoundCount();
    } else {
      isOneSideSaiRunCompleted = true;
      await _updateRoundCount();
    }
  }

  void cancelPositionStreamSubscription() {
    positionStreamSubscription?.cancel();
    positionStreamSubscription = null;
  }

  @override
  void dispose() {
    cancelPositionStreamSubscription();
    scrollController.dispose();
    super.dispose();
  }
}
