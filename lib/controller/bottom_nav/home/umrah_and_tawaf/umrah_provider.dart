import '../../../../export.dart';

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

  UserActivityType userActivityType = UserActivityType.umrah;
  bool isLoading = false;

  HistoryModel? umrahModel;

  bool isPerformed2RakatsSalah = false;
  bool isDrinkZamzam = false;

  StreamSubscription<Position>? positionStreamSubscription;

  bool hasDoneBeforeMeeqaatTasks = false;
  bool hasReachedMeeqaat = false;
  bool hasDoneAfterMeeqaatTasks = false;
  bool hasDoneHalfCircle = false;
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = true;
  int tawafCircleCount = 0;

  bool isTrackerPaused = false;

  bool showSafaMarwa = false;
  bool isSafaMarwaComplete = false;

  bool isUmrahCompleted = false;
  bool isShavedHead = false;
  Position? startingPosition;

  UserModel? user;

  bool canPop = false;

  void onPopInvokedWithResult(bool didPop, result) async {
    if (canPop || didPop) return;
    var dialogResult = await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: userActivityType == UserActivityType.umrah ? LocaleKeys.exit_umrah_confirmation.tr() : LocaleKeys.exit_tawaf_confirmation.tr()),
    );
    if (dialogResult == true) {
      canPop = true;
      Navigator.pop(context);
    }
  }

  Future<void> initialization(UserActivityType userActivityType) async {
    isLoading = true;
    notifyListeners();
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
    isLoading = false;
    if (context.mounted) notifyListeners();
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
  }

  Future<void> _initializeTawafLocationTracking() async {}

  Future<void> startNextRound() async {
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

  void moveToSafaMarwa() {
    if (userActivityType == UserActivityType.tawaf) {
      _resetTawafData();
      infoToast(LocaleKeys.your_tawaf_has_been_successfully_completed.tr());
      return Navigator.pop(context);
    }

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

  void perform2RakatsSalah() {
    isPerformed2RakatsSalah = !isPerformed2RakatsSalah;
    notifyListeners();
  }

  void drinkZamzam() {
    isDrinkZamzam = !isDrinkZamzam;
    notifyListeners();
  }

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

  void _cancelPositionStreamSubscription() {
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
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
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
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
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
