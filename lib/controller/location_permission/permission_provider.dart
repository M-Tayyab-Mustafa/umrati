import '../../export.dart';

final locationPermissionProvider = ChangeNotifierProvider.autoDispose<LocationPermissionNotifier>((ref) => LocationPermissionNotifier());

class LocationPermissionNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  bool isLoading = false;
  Timer? bounceTimer;

  @override
  void dispose() {
    bounceTimer?.cancel();
    super.dispose();
  }

  void skip() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog(title: LocaleKeys.confirmation_dialog.tr()));
    if (result == false || result == null) {
      return;
    }
    ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
  }

  void continueTab() async {
    isLoading = true;
    notifyListeners();
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.deniedForever || status == LocationPermission.denied) {
      var newStatus = await Geolocator.requestPermission();
      if (newStatus == LocationPermission.deniedForever) {
        isLoading = false;
        notifyListeners();
        await openAppSettings();
        bounceTimer?.cancel();
        bounceTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
          var status = await Geolocator.checkPermission();
          if (status == LocationPermission.always || status == LocationPermission.whileInUse) {
            bounceTimer?.cancel();
            ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
          }
        });
      } else {
        ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
      }
    } else {
      ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
    }
  }
}
