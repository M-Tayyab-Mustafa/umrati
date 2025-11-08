import '../../../../export.dart';

// Provider for TawafNotifier using ChangeNotifier
final umrahProvider = ChangeNotifierProvider.autoDispose<UmrahNotifier>((ref) {
  final notifier = UmrahNotifier();
  ref.onDispose(() {
    if (notifier.userActivityType == UserActivityType.tawaf) notifier.updateUmrahModel(notifier.umrahModel!.copyWith(is_doing: false));
  });
  return notifier;
});

class UmrahNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  // Flag to track if user is currently performing Tawaf
  UserActivityType userActivityType = UserActivityType.umrah;
  bool isLoading = false;

  HistoryModel? umrahModel;

  // Flags for Tawaf requirements
  bool isPerformed2RakatsSalah = false;
  bool isDrinkZamzam = false;

  StreamSubscription<Position>? positionStreamSubscription;

  // Tawaf round tracking
  bool hasDoneBeforeMeeqaatTasks = false;
  bool hasReachedMeeqaat = false;
  bool hasDoneAfterMeeqaatTasks = false;
  bool hasDoneHalfCircle = false;
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = true;
  int tawafCircleCount = 0;

  bool isTrackerPaused = false;

  // Completion flags for different stages
  bool showSafaMarwa = false;
  bool isSafaMarwaComplete = false;

  //* umrah Complete
  bool isUmrahCompleted = false;
  bool isShavedHead = false;
  Position? startingPosition;

  UserModel? user;

  bool canPop = false;

  void onPopInvokedWithResult(bool didPop, result) async {
    if (canPop || didPop) return;
    var dialogResult = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.exit_umrah_confirmation.tr()));
    if (dialogResult == true) {
      canPop = true;
      Navigator.pop(context);
    }
  }

  // Initialize TawafNotifier
  Future<void> initialization(UserActivityType userActivityType) async {
    canPop = false;
    this.userActivityType = userActivityType;
    ref.read(meeqaatTwoTasksProvider.notifier).updateLoading(true);
    user = (await LocalStorageManager.getUser(fromFirebase: true))!;
    if (userActivityType == UserActivityType.umrah) {
      final querySnapshot = await historyCollection.where(Filter.and(Filter('user_id', isEqualTo: user!.uid), Filter('is_doing', isEqualTo: true), Filter('type', isEqualTo: UserActivityType.umrah.name))).get();
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first.reference;
        umrahModel = HistoryModel.fromMap((await doc.get()).data()!);
        var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlreadyDialog(isDoingUmrah: true));
        if (result == true) {
          hasDoneBeforeMeeqaatTasks = umrahModel!.has_done_before_meeqaat_tasks;
          hasReachedMeeqaat = umrahModel!.has_reached_meeqaat;
          hasDoneAfterMeeqaatTasks = umrahModel!.has_done_after_meeqaat_tasks;
          tawafCircleCount = umrahModel!.tawaf_circle_count;
          if (umrahModel!.sai_round_count == 7) {
            safaMarwaCompleted();
          } else {
            if (umrahModel!.can_start_sai) showSafaMarwa = true;
          }
          if (context.mounted) notifyListeners();
        } else {
          await updateUmrahModel(umrahModel!.copyWith(is_doing: false));
          umrahModel = null;
          _resetTawafData();
          isRoundCompleted = true;
          if (context.mounted) notifyListeners();
        }
      }
    } else {
      await _fromTawaf();
    }

    if (umrahModel != null && hasDoneBeforeMeeqaatTasks && hasReachedMeeqaat && hasDoneAfterMeeqaatTasks && tawafCircleCount < 7) await _startTawaf();
    if (context.mounted) ref.read(meeqaatTwoTasksProvider.notifier).updateLoading(false);
  }

  Future<void> _fromTawaf() async {
    hasDoneBeforeMeeqaatTasks = true;
    hasReachedMeeqaat = true;
    hasDoneAfterMeeqaatTasks = true;
    notifyListeners();
    if (umrahModel != null) {
      await updateUmrahModel(umrahModel!.copyWith(has_done_before_meeqaat_tasks: true, has_reached_meeqaat: true, has_done_after_meeqaat_tasks: true));
    } else {
      await setUmrahModel(
        HistoryModel(
          uid: '',
          user_id: user!.uid,
          type: UserActivityType.tawaf.name,
          is_doing: true,
          has_done_before_meeqaat_tasks: true,
          has_reached_meeqaat: true,
          has_done_after_meeqaat_tasks: true,
          can_start_sai: false,
          tawaf_circle_count: 0,
          sai_round_count: 0,
          is_one_side_sai_run_completed: false,
        ),
      );
    }
    notifyListeners();
  }

  // Method to start or stop Tawaf
  Future<void> pauseAndResumeTracker() async {
    if (!isTrackerPaused) {
      _pauseTracker();
    } else {
      _resumeTracker();
    }
  }

  void _pauseTracker() async {
    isLoading = true;
    notifyListeners();
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.are_you_sure_you_want_to_pause_tracking.tr()));
    if (result != true) return;
    // ref.read(safaMarwaProvider.notifier).cancelPositionStreamSubscription();
    _cancelPositionStreamSubscription();
    isTrackerPaused = true;
    isLoading = false;
    notifyListeners();
  }

  void _resumeTracker() async {
    isLoading = true;
    notifyListeners();
    if (umrahModel != null && umrahModel!.can_start_sai) {
      ref.read(safaMarwaProvider.notifier).initializeSafaMarwaLocationTracking();
    } else {
      _initializeTawafLocationTracking();
    }
    isTrackerPaused = false;
    isLoading = false;
    notifyListeners();
  }

  Future<void> _startTawaf() async {
    await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => StartConfirmationDialog());
    // startingPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
    // var constantsDoc = await settingsCollection.doc(CommonDoc.constants.name).get();
    // LatLng alHajarAlAswadLatLng = LatLng(constantsDoc.get(CommonField.alHajarAlAswad.name)!['lat'], constantsDoc.get(CommonField.alHajarAlAswad.name)!['lng']);
    // LatLng matafGreenLightLatLng = LatLng(constantsDoc.get(CommonField.matafGreenLight.name)!['lat'], constantsDoc.get(CommonField.matafGreenLight.name)!['lng']);
    // var threshold = num.parse(constantsDoc.get(CommonField.alHajarToMatafThreshold.name).toString());
    // await _checkReachedNearTheGreenLight(alHajarAlAswadLatLng: alHajarAlAswadLatLng, matafGreenLightLatLng: matafGreenLightLatLng, threshold: threshold);
    // tawafCircleCompletionPercent = 0;
    // notifyListeners();
    // try {
    //   await _initializeTawafLocationTracking();
    // } catch (e, stack) {
    //   debugPrint('Error requesting permission: $e\n$stack');
    //   _pauseTracker();
    // }
  }

  // Future<void> _checkReachedNearTheGreenLight({required LatLng alHajarAlAswadLatLng, required LatLng matafGreenLightLatLng, required num threshold}) async {
  //   try {
  // await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => StartConfirmationDialog());
  // var isUserInBetweenAlHajarAndMataf =
  //     Helper.distanceToVector(alHajarAlAswadLatLng, matafGreenLightLatLng, LatLng(startingPosition!.latitude, startingPosition!.longitude)) <= threshold.toDouble();
  // if (isUserInBetweenAlHajarAndMataf) return;
  // var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => StartConfirmationDialog());
  // if (result == true) {
  //   errorToast(LocaleKeys.you_are_not_near_the_green_light.tr());
  //   await _checkReachedNearTheGreenLight(alHajarAlAswadLatLng: alHajarAlAswadLatLng, matafGreenLightLatLng: matafGreenLightLatLng, threshold: threshold);
  // } else {
  //   goToHome();
  // }
  // } catch (e) {
  //   log(e.toString());
  // }
  // }

  // Method to request location permissions and initialize Tawaf
  Future<void> _initializeTawafLocationTracking() async {
    // try {
    //   positionStreamSubscription?.cancel();
    //   var alKabaLatLongDoc = await settingsCollection.doc(CommonDoc.alKaba.name).get();
    //   var kabaLatLng = LatLng(alKabaLatLongDoc.data()!['lat'], alKabaLatLongDoc.data()!['lng']);
    //   // Start listening to position updates
    //   positionStreamSubscription = Geolocator.getPositionStream(
    //     locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
    //   ).listen((position) => _updateLocation(position, startingPosition!, kabaLatLng));
    // } catch (e) {
    //   if (kDebugMode) log(e.toString());
    //   errorToast(e.toString());
    // }
  }

  // Method to update location and track Tawaf progress
  // Future<void> _updateLocation(Position currentPosition, Position startingPosition, LatLng kabaLatLng) async {
  // // Keep 12 meters distance minimum from kaba.
  // var distance = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, kabaLatLng.latitude, kabaLatLng.longitude);
  // if (distance < 12) return;
  // // Exit early if Tawaf is not active or subscription is null
  // if (umrahModel == null || positionStreamSubscription == null) {
  //   _cancelPositionStreamSubscription();
  //   return;
  // }

  // final currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
  // final startingLatLng = LatLng(startingPosition.latitude, startingPosition.longitude);

  // // Calculate bearings from Kaaba to starting and current positions
  // double startBearing = Helper.calculateBearing(kabaLatLng, startingLatLng);
  // double currentBearing = Helper.calculateBearing(kabaLatLng, currentLatLng);

  // // Calculate progress angle in anti-clockwise direction
  // double progressAngle = Helper.antiClockwiseDelta(startBearing, currentBearing);
  // if (!isRoundCompleted) tawafCircleCompletionPercent = (progressAngle / 360).clamp(0.0, 1.0);
  // if (tawafCircleCompletionPercent >= 0.5 && tawafCircleCompletionPercent <= 0.8) hasDoneHalfCircle = true;
  // if (tawafCircleCompletionPercent >= 0.985 && !hasDoneHalfCircle) tawafCircleCompletionPercent = 0;
  // if (tawafCircleCompletionPercent >= 0.985 && hasDoneHalfCircle) {
  //   isRoundCompleted = true;
  //   hasDoneHalfCircle = false;
  //   tawafCircleCount++;
  //   if (await Vibration.hasVibrator()) Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);
  //   updateUmrahModel(umrahModel!.copyWith(tawaf_circle_count: tawafCircleCount));
  //   tawafCircleCompletionPercent = 0;
  // }
  // notifyListeners();
  // }

  //Todo:: Remove After Testing...
  void debugSkipTawaf() async {
    isRoundCompleted = true;
    tawafCircleCount++;
    tawafCircleCompletionPercent = 0;
    notifyListeners();
    if (await Vibration.hasVibrator()) Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);
    await updateUmrahModel(umrahModel!.copyWith(tawaf_circle_count: tawafCircleCount));
  }

  // Method to start the next Tawaf round
  startNextRound() async {
    isRoundCompleted = false;
    notifyListeners();
  }

  void completeRound() async {
    isRoundCompleted = true;
    tawafCircleCount++;
    if (await Vibration.hasVibrator()) Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);
    updateUmrahModel(umrahModel!.copyWith(tawaf_circle_count: tawafCircleCount));
    notifyListeners();
  }

  /// Moves user to Safa-Marwa section after completing Tawaf
  void moveToSafaMarwa() {
    if (userActivityType == UserActivityType.tawaf) {
      _resetTawafData();
      infoToast(LocaleKeys.your_tawaf_has_been_successfully_completed.tr());
      return Navigator.pop(context);
    }
    // Ensure prerequisites for Safa-Marwa are met
    if (!isPerformed2RakatsSalah || !isDrinkZamzam) {
      errorToast(LocaleKeys.please_offer_two_rakat_of_salah_and_drink_zamzam.tr());
      return;
    }
    updateUmrahModel(umrahModel!.copyWith(can_start_sai: true));

    showSafaMarwa = true;
    isSafaMarwaComplete = false;
    notifyListeners();
  }

  void _resetTawafData() {
    hasDoneBeforeMeeqaatTasks = false;
    hasReachedMeeqaat = false;
    hasDoneAfterMeeqaatTasks = false;
    tawafCircleCount = 0;
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
    notifyListeners();
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

  // Method to mark Umrah as completed
  void umrahCompleted() async {
    isLoading = true;
    notifyListeners();
    umrahModel = umrahModel!.copyWith(is_doing: false);
    user = user!.copyWith(total_umrah_done: user!.total_umrah_done + 1);
    await LocalStorageManager.saveUser(user!);
    await updateUmrahModel(umrahModel!);
    umrahModel = null;
    isLoading = false;
    isUmrahCompleted = true;
    notifyListeners();
  }

  // Method to return to home state
  void goToHome() {
    showSafaMarwa = false;
    isUmrahCompleted = false;
    isSafaMarwaComplete = false;
    _resetTawafData();
    Navigator.pop(context);
  }

  void toggleShaveTheHead() {
    isShavedHead = !isShavedHead;
    notifyListeners();
  }

  void safaMarwaCompleted() async {
    isSafaMarwaComplete = true;
    notifyListeners();
  }

  _cancelPositionStreamSubscription() {
    positionStreamSubscription?.cancel();
    positionStreamSubscription = null;
  }

  Future<void> updateHasDoneBeforeMeeqaatTasks() async {
    await setUmrahModel(
      HistoryModel(
        uid: '',
        user_id: user!.uid,
        type: userActivityType.name,
        is_doing: true,
        has_done_before_meeqaat_tasks: true,
        has_reached_meeqaat: false,
        has_done_after_meeqaat_tasks: false,
        can_start_sai: false,
        tawaf_circle_count: 0,
        sai_round_count: 0,
        is_one_side_sai_run_completed: false,
      ),
    );
    hasDoneBeforeMeeqaatTasks = true;
    notifyListeners();
  }

  Future<bool> continueYourRemainingTasks() async {
    try {
      umrahModel = umrahModel!.copyWith(has_reached_meeqaat: true);
      await updateUmrahModel(umrahModel!);
      hasReachedMeeqaat = true;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
      return false;
    }
  }

  Future<void> updateHasDoneAfterMeeqaatTasks() async {
    try {
      umrahModel = umrahModel!.copyWith(has_done_after_meeqaat_tasks: true);
      await updateUmrahModel(umrahModel!);
      hasDoneAfterMeeqaatTasks = true;
      notifyListeners();
      await _startTawaf();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  Future<void> updateUmrahModel(HistoryModel umrah) async {
    var doc = historyCollection.doc(umrah.uid);
    await doc.update(umrah.toMap(updated_at: FieldValue.serverTimestamp()));
    umrahModel = HistoryModel.fromMap((await doc.get()).data()!);
  }

  Future<void> setUmrahModel(HistoryModel umrah) async {
    var doc = historyCollection.doc();
    await doc.set(umrah.copyWith(uid: doc.id).toMap(created_at: FieldValue.serverTimestamp(), updated_at: FieldValue.serverTimestamp()));
    umrahModel = HistoryModel.fromMap((await doc.get()).data()!);
  }

  void onCountTap() => Fluttertoast.showToast(msg: LocaleKeys.count_increase_tip.tr(), gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_SHORT);

  @override
  void dispose() {
    _cancelPositionStreamSubscription();
    super.dispose();
  }
}
