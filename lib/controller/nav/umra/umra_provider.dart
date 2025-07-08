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

  UserModel? _user;
  UserModel get user => _user!;

  // Initialize TawafNotifier
  initialization(BuildContext context) async {
    _user = await LocalStorageManager.getUser();
    tawafCircleCount = user.tawafCircleCount;
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
        LocalStorageManager.saveUser(user.copyWith(tawafCircleCount: 0, isOneSideSaiRunCompleted: false, saiRoundCount: 0));
      }
      notifyListeners();
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
      await _startTawaf(context);
    }
  }

  void _stopTawaf() {
    isInTawaf = false;
    showSafaMarwa = false;
    isSafaMarwaComplete = false;
    _resetTawafData();
    _cancelPositionStreamSubscription();
    LocalStorageManager.saveUser(user.copyWith(tawafCircleCount: 0, isOneSideSaiRunCompleted: false, saiRoundCount: 0));
  }

  Future<void> _startTawaf(BuildContext context) async {
    isInTawaf = true;
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
    // Reset tracking variables
    tawafCircleCompletionPercent = 0;
    notifyListeners();

    // Get current position and Kaaba coordinates
    var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
    var alKabaLatLongDoc = await settingsCollection.doc(CommonDoc.alKaba.name).get();
    var kabaLatLng = LatLng(alKabaLatLongDoc.data()!['lat'], alKabaLatLongDoc.data()!['lng']);
    // Start listening to position updates
    positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((position) => _updateLocation(position, currentPosition, kabaLatLng));
  }

  Future<void> _updateLocation(Position currentPosition, Position startingPosition, LatLng kabaLatLng) async {
    try {
      // Exit early if Tawaf is not active or subscription is null
      if (!isInTawaf || positionStreamSubscription == null) {
        _cancelPositionStreamSubscription();
        return;
      }

      final currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
      final startingLatLng = LatLng(startingPosition.latitude, startingPosition.longitude);

      // Calculate bearings from Kaaba to starting and current positions
      final startBearing = calculateBearing(kabaLatLng, startingLatLng);
      final currentBearing = calculateBearing(kabaLatLng, currentLatLng);

      // Calculate anti-clockwise progress angle
      double progressAngle = (startBearing - currentBearing) % 360;
      if (progressAngle < 0) progressAngle += 360;
      // Don't proceed if no progress made
      if (progressAngle == 0) return;

      tawafCircleCompletionPercent = (progressAngle / 360).clamp(0.0, 1.0);

      // If a full round is completed
      if (tawafCircleCompletionPercent >= 0.99) {
        isRoundCompleted = true;
        tawafCircleCount++;

        // Persist data and cleanup
        _cancelPositionStreamSubscription();
        await LocalStorageManager.saveUser(user.copyWith(tawafCircleCount: tawafCircleCount));
      }
      notifyListeners();
    } catch (e, stackTrace) {
      log('Tawaf location update error: $e\n$stackTrace');
      _cancelPositionStreamSubscription();
    }
  }

  // Method to start the next Tawaf round
  startNextRound(BuildContext context) {
    isRoundCompleted = false;
    _initializeTawafLocationTracking(context);
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
