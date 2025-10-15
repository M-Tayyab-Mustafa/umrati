import '../../../export.dart';
import '../../../view/bottom_nav/home/ziarat/map.dart';

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
  ZiaraatHistoryModel? ziaratHistory;
  bool isLoading = true;

  Future<void> initialization(ZiaraatHistoryModel ziaratHistory) async {
    isLoading = true;
    notifyListeners();
    this.ziaratHistory = ziaratHistory;
    user = await LocalStorageManager.getUser();
    myCurrentLocation = await Helper.getLocation(context);
    await getDistance();
    isLoading = false;
    notifyListeners();
  }

  Future<void> getDistance() async {
    try {
      sortZiarats(position: await Geolocator.getCurrentPosition());
      positionStream = Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation)).listen((position) async {
        if (!context.mounted) return positionStream?.cancel();
        sortZiarats(position: position);
      });
    } catch (e) {
      if (kDebugMode) log(e.toString());
      if (context.mounted) errorToast(e.toString());
    }
  }

  void sortZiarats({required Position position}) {
    var remainingZiarats =
        ziaratHistory!.remainingZiarats.map<ZiaraatModel>((ziarat) {
            var distance = Geolocator.distanceBetween(position.latitude, position.longitude, ziarat.lat.toDouble(), ziarat.lng.toDouble());
            return ziarat.copyWith(distance: (distance / 1000).toStringAsFixed(0));
          }).toList()
          ..sort((a, b) => int.parse(a.distance).compareTo(int.parse(b.distance)));
    var completedZiarats =
        ziaratHistory!.completedZiarats.map<ZiaraatModel>((ziarat) {
            var distance = Geolocator.distanceBetween(position.latitude, position.longitude, ziarat.lat.toDouble(), ziarat.lng.toDouble());
            return ziarat.copyWith(distance: (distance / 1000).toStringAsFixed(0));
          }).toList()
          ..sort((a, b) => int.parse(a.distance).compareTo(int.parse(b.distance)));
    ziaratHistory = ziaratHistory!.copyWith(remainingZiarats: remainingZiarats, completedZiarats: completedZiarats);
    if (context.mounted) notifyListeners();
  }

  void resume() async => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ZiaraatMapPage(ziaratHistory: ziaratHistory!)));

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }
}
