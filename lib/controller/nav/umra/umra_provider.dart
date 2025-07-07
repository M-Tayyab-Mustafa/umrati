import 'package:latlong2/latlong.dart';
import '../../../export.dart' hide LatLng;
part '../../../utils/helper/tawaf.dart';

// Provider for TawafNotifier using ChangeNotifier
final tawafProvider = ChangeNotifierProvider.autoDispose<TawafNotifier>((ref) => TawafNotifier());

class TawafNotifier extends ChangeNotifier {
  // Flag to track if user is currently performing Tawaf
  bool isInTawaf = false;
  UserModel? user;

  bool isFromumra = true;

  // Flags for Tawaf requirements
  bool isPerformed2RakatsSalah = false;
  bool isDrinkZamzam = false;

  // Tawaf round tracking
  double tawafCircleCompletionPercent = 0;
  bool isRoundCompleted = false;
  int circleCount = 0; // Total rounds required for Tawaf

  // Completion flags for different stages
  bool showSafaMarwa = false;
  bool isSafaMarwaComplete = false;

  //* umra Complete
  bool isUmraCompleted = false;
  bool isShavedHead = false;

  // Initialize TawafNotifier
  initialization(BuildContext context) async {
    user ??= await LocalStorageManager.getUser();
    if ((int.tryParse(user!.tawaf_circle_count) ?? 0) > 0) {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlreadyDialog(isDoingumra: true));
      if (result == null) return;
      if (result == true) {
        isInTawaf = true;
        if ((int.tryParse(user!.tawaf_circle_count) ?? 0) >= 7) {
          showSafaMarwa = true;
        }
      } else {
        await LocalStorageManager.saveUser(user!.copyWith(tawaf_circle_count: '0'));
      }
    }
    user = await LocalStorageManager.getUser();

    if (isInTawaf) {
      if (kDebugMode) {
        _updateCircleTemp();
      } else {
        _getPermission(context);
      }
    }
  }

  // Method to start or stop Tawaf
  startTawaf(BuildContext context) async {
    if (isInTawaf) {
      isInTawaf = false;
      showSafaMarwa = false;
      isSafaMarwaComplete = false;
      positionStreamSubscription?.cancel();
      user = user!.copyWith(tawaf_circle_count: '0');
      LocalStorageManager.saveUser(user!);
      _resetTawaf();
      return;
    }
    // Start Tawaf
    isInTawaf = true;
    notifyListeners();
    if (kDebugMode) {
      _updateCircleTemp();
    } else {
      _getPermission(context);
    }
  }

  _updateCircleTemp() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!(circleCount >= 7)) {
        if (tawafCircleCompletionPercent >= 0.9) {
          isRoundCompleted = true;
          circleCount++;
          timer.cancel();
          user = user!.copyWith(tawaf_circle_count: '$circleCount');
          LocalStorageManager.saveUser(user!);
        } else {
          tawafCircleCompletionPercent = tawafCircleCompletionPercent + 0.5;
        }
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  // Method to request location permissions and initialize Tawaf
  Future<void> _getPermission(BuildContext context) async {
    // Reset tracking variables
    tawafCircleCompletionPercent = 0;
    notifyListeners();

    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Get current position and Kaaba coordinates
      var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      var alKabaLatLongDoc = await settingsCollection.doc(CommonDoc.alKaba.name).get();
      var kabaLatLng = LatLng(alKabaLatLongDoc.data()!['lat'], alKabaLatLongDoc.data()!['lng']);

      // Start listening to position updates
      positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 1),
      ).listen((position) => _updateLocation(position, currentPosition, kabaLatLng));
    } else {
      errorToast(LocaleKeys.please_allow_location_permissions.tr());
      _resetTawaf();
    }
  }

  // Method to update location and track Tawaf progress
  Future<void> _updateLocation(Position currentPosition, Position startingPosition, LatLng kabaLatLng) async {
    if (circleCount >= 7) {
      positionStreamSubscription?.cancel();
      user = user!.copyWith(tawaf_circle_count: '$circleCount');
      LocalStorageManager.saveUser(user!);
    }
    final currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    final startingLatLng = LatLng(startingPosition.latitude, startingPosition.longitude);

    // Calculate bearings from Kaaba to starting and current positions
    double startBearing = calculateBearing(kabaLatLng, startingLatLng);
    double currentBearing = calculateBearing(kabaLatLng, currentLatLng);

    // Calculate progress angle in anti-clockwise direction
    double progressAngle = antiClockwiseDelta(startBearing, currentBearing);

    if (progressAngle > 0) {
      tawafCircleCompletionPercent = (progressAngle / 360).clamp(0.0, 1.0);
      if (progressAngle >= 360) {
        isRoundCompleted = true;
        circleCount++;
        positionStreamSubscription?.cancel();
        user = user!.copyWith(tawaf_circle_count: '$circleCount');
        LocalStorageManager.saveUser(user!);
      }
    }
    notifyListeners();
  }

  // Method to start the next Tawaf round
  startNextRound(BuildContext context) {
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
    if (kDebugMode) {
      _updateCircleTemp();
    } else {
      _getPermission(context);
    }
    notifyListeners();
  }

  // Method to reset Tawaf tracking variables
  _resetTawaf() {
    circleCount = 0;
    LocalStorageManager.saveUser(user!);
    tawafCircleCompletionPercent = 0;
    isRoundCompleted = false;
    notifyListeners();
  }

  // Method to move to Safa-Marwa after completing Tawaf
  moveToSafaMarwa({required BuildContext context, required WidgetRef ref}) {
    if (!isFromumra) {
      Navigator.pop(context);
      LocalStorageManager.saveUser(user!.copyWith(tawaf_circle_count: '0'));
      infoToast(LocaleKeys.your_tawaf_has_been_successfully_completed.tr());
      return;
    }
    if (isPerformed2RakatsSalah == false || isDrinkZamzam == false) {
      errorToast(LocaleKeys.please_offer_two_rakat_of_salah_and_drink_zamzam.tr());

      return;
    }
    isSafaMarwaComplete = false;
    showSafaMarwa = true;
    _resetTawaf();
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

  // Helper method to calculate anti-clockwise angle difference
  double antiClockwiseDelta(double from, double to) {
    double delta = from - to;
    if (delta < 0) delta += 360;
    return delta;
  }

  void toggleShaveTheHead() {
    isShavedHead = !isShavedHead;
    notifyListeners();
  }

  void isSafaMarwaCompleted() async {
    isSafaMarwaComplete = true;
    await LocalStorageManager.saveUser(user!.copyWith(tawaf_circle_count: '0'));
    notifyListeners();
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }
}
