import '../../../../export.dart';

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

  Future<void> getLocation() async {
    try {
      isLoading = true;
      if (context.mounted) notifyListeners();
      await _updateLocation(await Geolocator.getCurrentPosition());
      isLoading = false;
      if (context.mounted) notifyListeners();
      positionStreamSubscription = Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation)).listen(_updateLocation);
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
  }

  Future<void> _updateLocation(Position position) async {
    Placemark placemarks = (await placemarkFromCoordinates(position.latitude, position.longitude)).first;
    location = '${placemarks.subLocality}, ${placemarks.locality}, ${placemarks.administrativeArea}';
    if (context.mounted) notifyListeners();
    var meeqaatDoc = await settingsCollection.doc(CommonDoc.meeqaat.name).get();
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
    var result = await ref.read(umrahProvider.notifier).continueYourRemainingTasks();
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
