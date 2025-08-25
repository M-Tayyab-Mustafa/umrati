import 'package:latlong2/latlong.dart';
import '../../../export.dart' hide LatLng;
part '../../../utils/helper/tawaf.dart';

// Provider for TawafNotifier using ChangeNotifier
final tawafProvider = ChangeNotifierProvider.autoDispose<TawafNotifier>((ref) => TawafNotifier());

class TawafNotifier extends ChangeNotifier {
  // Flag to track if user is currently performing Tawaf
  bool isInTawaf = false;

  bool isFromUmra = true;

  // Flags for Tawaf requirements
  bool isPerformed2RakatsSalah = false;
  bool isDrinkZamzam = false;

  StreamSubscription<Position>? positionStreamSubscription;

  // Tawaf round tracking
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = false;
  int tawafCircleCount = 0; // Total rounds required for Tawaf

  // Completion flags for different stages
  bool showSafaMarwa = false;
  bool isSafaMarwaComplete = false;

  //* umra Complete
  bool isUmraCompleted = false;
  bool isShavedHead = false;
  Position? startingPosition;

  UserModel? _user;
  UserModel? get user => _user;

  // Initialize TawafNotifier
  initialization(BuildContext context) async {
    _user = await LocalStorageManager.getUser(fromFirebase: true);
    tawafCircleCount = user!.tawafCircleCount;
    if (context.mounted) notifyListeners();
    if (tawafCircleCount > 0) {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlreadyDialog(isDoingUmra: true));
      if (result == null) return;
      if (result == true) {
        isInTawaf = true;
        if (tawafCircleCount >= 7) {
          _resetTawafData();
          showSafaMarwa = true;
        }
      } else {
        _resetTawafData();
        LocalStorageManager.saveUser(user!.copyWith(tawafCircleCount: 0, isOneSideSaiRunCompleted: false, saiRoundCount: 0));
      }
      if (context.mounted) notifyListeners();
    }

    if (isInTawaf) {
      _initializeTawafLocationTracking(context);
    }
  }

  // Method to start or stop Tawaf
  Future<void> toggleTawaf(BuildContext context) async {
    if (isInTawaf) {
      _stopTawaf();
    } else {
      await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => UmraStartConfirmationDialog());
      await _startTawaf(context);
    }
  }

  void _stopTawaf() {
    isInTawaf = false;
    showSafaMarwa = false;
    isSafaMarwaComplete = false;
    _resetTawafData();
    _cancelPositionStreamSubscription();
    LocalStorageManager.saveUser(user!.copyWith(tawafCircleCount: 0, isOneSideSaiRunCompleted: false, saiRoundCount: 0));
  }

  Future<void> _startTawaf(BuildContext context) async {
    isInTawaf = true;
    tawafCircleCompletionPercent = 0;
    notifyListeners();
    try {
      await _initializeTawafLocationTracking(context);
    } catch (e, stack) {
      debugPrint('Error requesting permission: $e\n$stack');
      _stopTawaf();
    }
  }

  // Method to request location permissions and initialize Tawaf
  Future<void> _initializeTawafLocationTracking(BuildContext context) async {
    try {
      startingPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
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
    if (!isInTawaf || positionStreamSubscription == null) {
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
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);
      }
      tawafCircleCompletionPercent = 0;
      LocalStorageManager.saveUser(user!.copyWith(tawafCircleCount: tawafCircleCount));
    }
    notifyListeners();
  }

  // Method to start the next Tawaf round
  startNextRound(BuildContext context) {
    isRoundCompleted = false;
    notifyListeners();
  }

  /// Moves user to Safa-Marwa section after completing Tawaf
  void moveToSafaMarwa({required BuildContext context, required WidgetRef ref}) {
    // Ensure prerequisites for Safa-Marwa are met
    if (!isPerformed2RakatsSalah || !isDrinkZamzam) {
      errorToast(LocaleKeys.please_offer_two_rakat_of_salah_and_drink_zamzam.tr());
      return;
    }
    _resetTawafData();
    if (!isFromUmra) {
      infoToast(LocaleKeys.your_tawaf_has_been_successfully_completed.tr());
      return;
    }
    showSafaMarwa = true;
    isSafaMarwaComplete = false;
    notifyListeners();
  }

  _resetTawafData() {
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
  void umraCompleted() {
    isUmraCompleted = true;
    notifyListeners();
  }

  // Method to return to home state
  void goToHome({required BuildContext context}) {
    isInTawaf = false;
    showSafaMarwa = false;
    isUmraCompleted = false;
    isSafaMarwaComplete = false;
    notifyListeners();
  }

  void toggleShaveTheHead() {
    isShavedHead = !isShavedHead;
    notifyListeners();
  }

  void isSafaMarwaCompleted() async {
    isSafaMarwaComplete = true;
    notifyListeners();
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
