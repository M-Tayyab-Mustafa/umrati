import '../../../export.dart';

final locationFetchProvider = ChangeNotifierProvider.autoDispose<MeeqaatLocationFetchProviderNotifier>((ref) => MeeqaatLocationFetchProviderNotifier());

class MeeqaatLocationFetchProviderNotifier extends ChangeNotifier {
  String location = '';
  String? distance;
  String? time;
  StreamSubscription<Position>? positionStreamSubscription;
  bool isLoading = false;

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  getLocation() async {
    try {
      await _updateLocation(await Geolocator.getCurrentPosition());
      positionStreamSubscription = Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation)).listen(_updateLocation);
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  Future<void> _updateLocation(Position position) async {
    Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
    location = '${placemarks.street}, ${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
    if (context.mounted) notifyListeners();
    var meeqaatDoc = await FirebaseFirestore.instance.collection(CollectionNames.settings.name).doc(CommonDoc.meeqaat.name).get();
    final leg = await Helper.getRouteLeg(startPoint: LatLng(position.latitude, position.longitude), endPoint: LatLng(meeqaatDoc.get('lat'), meeqaatDoc.get('lng')));
    if (leg != null) {
      distance = leg['distance']['text'];
      time = leg['duration']['text'];
    }
    if (context.mounted) notifyListeners();
  }

  void onContinueYourRemainingTasks() async {
    isLoading = true;
    if (context.mounted) notifyListeners();
    var result = await ref.read(umraProvider.notifier).continueYourRemainingTasks();
    if (result) positionStreamSubscription?.cancel();
    isLoading = false;
    if (context.mounted) notifyListeners();
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }
}
