import '../../../export.dart';
import '../../../view/bottom_nav/home/ziaraat/map.dart';

final ziaraatDetailProvider = ChangeNotifierProvider.autoDispose<ZiaraatDetailNotifier>((ref) => ZiaraatDetailNotifier());

class ZiaraatDetailNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  String myCurrentLocation = '';
  UserModel? user;
  StreamSubscription<Position>? positionStream;
  ZiaraatHistoryModel? ziaraatHistory;
  bool isLoading = true;

  Future<void> initialization(ZiaraatHistoryModel ziaraatHistory) async {
    isLoading = true;
    notifyListeners();
    this.ziaraatHistory = ziaraatHistory;
    user = await LocalStorageManager.getUser();
    myCurrentLocation = await Helper.getLocation(context);
    await getDistance();
    isLoading = false;
    notifyListeners();
  }

  Future<void> getDistance() async {
    try {
      sortZiaraats(position: await Geolocator.getCurrentPosition());
      positionStream = Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation)).listen((position) async {
        if (!context.mounted) return positionStream?.cancel();
        sortZiaraats(position: position);
      });
    } catch (e) {
      appLog(e.toString());
      errorToast(LocaleKeys.some_thing_went_wrong.tr());
    }
  }

  void sortZiaraats({required Position position}) {
    var remainingZiaraats =
        ziaraatHistory!.remainingZiaraats.map<ZiaraatModel>((ziaraat) {
            var distance = Geolocator.distanceBetween(position.latitude, position.longitude, ziaraat.lat.toDouble(), ziaraat.lng.toDouble());
            return ziaraat.copyWith(distance: (distance / 1000).toStringAsFixed(0));
          }).toList()
          ..sort((a, b) => int.parse(a.distance).compareTo(int.parse(b.distance)));
    var completedZiaraats =
        ziaraatHistory!.completedZiaraats.map<ZiaraatModel>((ziaraat) {
            var distance = Geolocator.distanceBetween(position.latitude, position.longitude, ziaraat.lat.toDouble(), ziaraat.lng.toDouble());
            return ziaraat.copyWith(distance: (distance / 1000).toStringAsFixed(0));
          }).toList()
          ..sort((a, b) => int.parse(a.distance).compareTo(int.parse(b.distance)));
    ziaraatHistory = ziaraatHistory!.copyWith(remainingZiaraats: remainingZiaraats, completedZiaraats: completedZiaraats);
    if (context.mounted) notifyListeners();
  }

  void resume() async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ZiaraatMapPage(ziaraatHistory: ziaraatHistory!)));

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }
}
