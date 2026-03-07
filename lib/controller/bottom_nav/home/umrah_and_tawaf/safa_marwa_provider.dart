import '../../../../export.dart';

final safaMarwaProvider = ChangeNotifierProvider.autoDispose<SafaMarwaNotifier>((ref) => SafaMarwaNotifier());

class SafaMarwaNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  late HistoryModel umrahModel;

  int saiRoundCount = 0;

  double distanceBetweenSafaAndMarwa = 0;
  SafaMarwaModel? safaMarwaModel;

  Future<void> initialization() async {
    umrahModel = ref.read(umrahProvider.notifier).umrahModel!;

    saiRoundCount = umrahModel.sai_round_count;

    await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => StartConfirmationDialog(fromUmrah: false));
  }

  Future<void> initializeSafaMarwaLocationTracking() async {
    final safaLatLng = LatLng(safaMarwaModel!.safaLat, safaMarwaModel!.safaLng);
    final marwaLatLng = LatLng(safaMarwaModel!.marwaLat, safaMarwaModel!.marwaLng);
    final safaMarwaDistance = num.parse(safaMarwaModel!.distance);
    var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
    _updateLocation(currentPosition, safaLatLng, marwaLatLng, safaMarwaDistance, num.parse(safaMarwaModel!.threshold));
  }

  void _updateLocation(Position position, LatLng safaLatLng, LatLng marwaLatLng, num safaMarwaDistance, num threshold) async {}

  Future<void> updateRoundCount() async {
    await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.now_please_pray_while_facing_kibla.tr(), withContinueButton: true));
    saiRoundCount++;
    if (await Vibration.hasVibrator()) Vibration.vibrate(pattern: [500, 1000, 500, 2000, 500, 1000, 500, 2000], intensities: [1, 128, 255]);

    umrahModel = umrahModel.copyWith(sai_round_count: saiRoundCount);
    ref.read(umrahProvider.notifier).updateUmrahModel(umrahModel);
    notifyListeners();
    if (saiRoundCount == 7) {
      saiRoundCount = 0;
      notifyListeners();
      ref.read(umrahProvider).safaMarwaCompleted();
    }
  }

  void onCountTap() => Fluttertoast.showToast(msg: LocaleKeys.count_increase_tip.tr(), gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_SHORT);

}
