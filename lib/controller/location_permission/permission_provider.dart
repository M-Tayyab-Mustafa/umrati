import '../../export.dart';

final locationPermissionProvider = ChangeNotifierProvider.autoDispose<LocationPermissionNotifier>((ref) => LocationPermissionNotifier());

class LocationPermissionNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  void skip() async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => SkipConfirmationDialog());
    if (result == false || result == null) {
      return;
    }
    ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
  }

  void continueTab() async {
    var result = await Geolocator.requestPermission();
    if (result == LocationPermission.deniedForever) {
      await openAppSettings();
    }
    ref.read(splashProvider.notifier).redirections(context, showPermissionPage: false);
  }
}
