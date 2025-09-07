import 'package:latlong2/latlong.dart';
import '../../../export.dart' hide LatLng;
part '../../../utils/helper/tawaf.dart';

// Provider for TawafNotifier using ChangeNotifier
final umraProvider = ChangeNotifierProvider.autoDispose<UmraNotifier>((ref) => UmraNotifier());

class UmraNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  // Flag to track if user is currently performing Tawaf
  bool isFromTawaf = false;
  bool isLoading = false;

  HistoryModel? umraModel;

  // Flags for Tawaf requirements
  bool isPerformed2RakatsSalah = false;
  bool isDrinkZamzam = false;

  StreamSubscription<Position>? positionStreamSubscription;

  // Tawaf round tracking
  bool hasDoneBeforeMeeqaatTasks = false;
  bool hasReachedMeeqaat = false;
  bool hasDoneAfterMeeqaatTasks = false;
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = false;
  int tawafCircleCount = 0;

  // Completion flags for different stages
  bool showSafaMarwa = false;
  bool isSafaMarwaComplete = false;

  //* umra Complete
  bool isUmraCompleted = false;
  bool isShavedHead = false;
  Position? startingPosition;

  UserModel? user;

  // Initialize TawafNotifier
  Future<void> initialization() async {
    ref.read(meeqaatTwoTasksProvider.notifier).updateLoading(true);
    user = (await LocalStorageManager.getUser(fromFirebase: true))!;
    final querySnapshot =
        await FirebaseFirestore.instance.collection(CollectionNames.histories.name).where(Filter.and(Filter('user_id', isEqualTo: user!.uid), Filter('is_doing', isEqualTo: true))).get();
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first.reference;
      umraModel = HistoryModel.fromMap((await doc.get()).data()!);
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlreadyDialog(isDoingUmra: true));
      if (result == true) {
        hasDoneBeforeMeeqaatTasks = umraModel!.has_done_before_meeqaat_tasks;
        hasReachedMeeqaat = umraModel!.has_reached_meeqaat;
        hasDoneAfterMeeqaatTasks = umraModel!.has_done_after_meeqaat_tasks;
        tawafCircleCount = umraModel!.tawaf_circle_count;
        if (umraModel!.sai_round_count == 7) {
          safaMarwaCompleted();
        } else {
          if (umraModel!.can_start_sai) showSafaMarwa = true;
        }
        if (context.mounted) notifyListeners();
      } else {
        await updateUmraModel(umraModel!.copyWith(is_doing: false));
        umraModel = null;
        _resetTawafData();
        if (isFromTawaf) _fromTawaf();
      }
    } else {
      if (isFromTawaf) _fromTawaf();
    }

    if (umraModel != null && hasDoneBeforeMeeqaatTasks && hasReachedMeeqaat && hasDoneAfterMeeqaatTasks && tawafCircleCount < 7) await _startTawaf();
    ref.read(meeqaatTwoTasksProvider.notifier).updateLoading(false);
  }

  _fromTawaf() async {
    var fromTawafDialogResult = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => TawafConfirmationDialog());
    if (fromTawafDialogResult != false) {
      hasDoneBeforeMeeqaatTasks = true;
      hasReachedMeeqaat = true;
      hasDoneAfterMeeqaatTasks = true;
      if (umraModel != null) {
        await updateUmraModel(umraModel!.copyWith(has_done_before_meeqaat_tasks: true, has_reached_meeqaat: true, has_done_after_meeqaat_tasks: true));
      } else {
        await setUmraModel(
          HistoryModel(
            uid: '',
            user_id: user!.uid,
            type: UmraType.tawaf.name,
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
  }

  // Method to start or stop Tawaf
  Future<void> startAndStopTawaf() async {
    if (umraModel != null) {
      _stopTawaf();
    } else {
      await _startTawaf();
    }
  }

  void _stopTawaf() async {
    isLoading = true;
    notifyListeners();
    showSafaMarwa = false;
    isSafaMarwaComplete = false;
    await updateUmraModel(umraModel!.copyWith(is_doing: false));
    umraModel = null;
    isPerformed2RakatsSalah = false;
    isDrinkZamzam = false;
    _resetTawafData();
    ref.read(safaMarwaProvider.notifier).positionStreamSubscription?.cancel();
    _cancelPositionStreamSubscription();
    isLoading = false;
    notifyListeners();
  }

  Future<void> _startTawaf() async {
    startingPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
    var constantsDoc = await settingsCollection.doc(CommonDoc.constants.name).get();
    var alHajarAlAswadLatLng = LatLng(constantsDoc.get(CommonField.alHajarAlAswad.name)!['lat'], constantsDoc.get(CommonField.alHajarAlAswad.name)!['lng']);
    var matafGreenLightLatLng = LatLng(constantsDoc.get(CommonField.matafGreenLight.name)!['lat'], constantsDoc.get(CommonField.matafGreenLight.name)!['lng']);
    var isUserInBetweenAlHajarAndMataf = Helper.isUserInBetweenAlHajarAndMataf(
      alHajarAlAswadLatLng.latitude,
      alHajarAlAswadLatLng.longitude,
      matafGreenLightLatLng.latitude,
      matafGreenLightLatLng.longitude,
      startingPosition!.latitude,
      startingPosition!.longitude,
      num.parse(constantsDoc.get(CommonField.alHajarToMatafThreshold.name).toString()).toDouble(),
    );
    if (!isUserInBetweenAlHajarAndMataf) await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => UmraStartConfirmationDialog());
    tawafCircleCompletionPercent = 0;
    notifyListeners();
    try {
      await _initializeTawafLocationTracking();
    } catch (e, stack) {
      debugPrint('Error requesting permission: $e\n$stack');
      _stopTawaf();
    }
  }

  // Method to request location permissions and initialize Tawaf
  Future<void> _initializeTawafLocationTracking() async {
    try {
      positionStreamSubscription?.cancel();
      var alKabaLatLongDoc = await settingsCollection.doc(CommonDoc.alKaba.name).get();
      var kabaLatLng = LatLng(alKabaLatLongDoc.data()!['lat'], alKabaLatLongDoc.data()!['lng']);
      // Start listening to position updates
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
      ).listen((position) => _updateLocation(position, startingPosition!, kabaLatLng));
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  // Method to update location and track Tawaf progress
  Future<void> _updateLocation(Position currentPosition, Position startingPosition, LatLng kabaLatLng) async {
    // Keep 12 meters distance minimum from kaba.
    var distance = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, kabaLatLng.latitude, kabaLatLng.longitude);
    if (distance < 12) return;
    // Exit early if Tawaf is not active or subscription is null
    if (umraModel == null || positionStreamSubscription == null) {
      _cancelPositionStreamSubscription();
      return;
    }

    final currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    final startingLatLng = LatLng(startingPosition.latitude, startingPosition.longitude);

    // Calculate bearings from Kaaba to starting and current positions
    double startBearing = calculateBearing(kabaLatLng, startingLatLng);
    double currentBearing = calculateBearing(kabaLatLng, currentLatLng);

    // Calculate progress angle in anti-clockwise direction
    double progressAngle = antiClockwiseDelta(startBearing, currentBearing);
    if (!isRoundCompleted) tawafCircleCompletionPercent = (progressAngle / 360).clamp(0.0, 1.0);
    if (tawafCircleCompletionPercent >= 0.975) {
      isRoundCompleted = true;
      tawafCircleCount++;
      if (await Vibration.hasVibrator()) Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);
      updateUmraModel(umraModel!.copyWith(tawaf_circle_count: tawafCircleCount));
      tawafCircleCompletionPercent = 0;
    }
    notifyListeners();
  }

  // Method to start the next Tawaf round
  startNextRound() {
    isRoundCompleted = false;
    notifyListeners();
  }

  /// Moves user to Safa-Marwa section after completing Tawaf
  void moveToSafaMarwa() {
    // Ensure prerequisites for Safa-Marwa are met
    if (!isPerformed2RakatsSalah || !isDrinkZamzam) {
      errorToast(LocaleKeys.please_offer_two_rakat_of_salah_and_drink_zamzam.tr());
      return;
    }
    updateUmraModel(umraModel!.copyWith(can_start_sai: true));
    if (isFromTawaf) {
      _resetTawafData();
      infoToast(LocaleKeys.your_tawaf_has_been_successfully_completed.tr());
      return;
    }
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

  // Method to mark Umra as completed
  void umraCompleted() async {
    isLoading = true;
    notifyListeners();
    umraModel = umraModel!.copyWith(is_doing: false);
    await updateUmraModel(umraModel!);
    umraModel = null;
    isLoading = false;
    isUmraCompleted = true;
    notifyListeners();
  }

  // Method to return to home state
  void goToHome() {
    showSafaMarwa = false;
    isUmraCompleted = false;
    isSafaMarwaComplete = false;
    _resetTawafData();
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
    await setUmraModel(
      HistoryModel(
        uid: '',
        user_id: user!.uid,
        type: isFromTawaf ? UmraType.tawaf.name : UmraType.umra.name,
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
      umraModel = umraModel!.copyWith(has_reached_meeqaat: true);
      await updateUmraModel(umraModel!);
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
      umraModel = umraModel!.copyWith(has_done_after_meeqaat_tasks: true);
      await updateUmraModel(umraModel!);
      hasDoneAfterMeeqaatTasks = true;
      notifyListeners();
      await _startTawaf();
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  Future<void> updateUmraModel(HistoryModel umra) async {
    var doc = FirebaseFirestore.instance.collection(CollectionNames.histories.name).doc(umra.uid);
    await doc.update(umra.toMap(updated_at: FieldValue.serverTimestamp()));
    umraModel = HistoryModel.fromMap((await doc.get()).data()!);
  }

  Future<void> setUmraModel(HistoryModel umra) async {
    var doc = FirebaseFirestore.instance.collection(CollectionNames.histories.name).doc();
    await doc.set(umra.copyWith(uid: doc.id).toMap(created_at: FieldValue.serverTimestamp(), updated_at: FieldValue.serverTimestamp()));
    umraModel = HistoryModel.fromMap((await doc.get()).data()!);
  }

  @override
  void dispose() {
    _cancelPositionStreamSubscription();
    super.dispose();
  }
}
