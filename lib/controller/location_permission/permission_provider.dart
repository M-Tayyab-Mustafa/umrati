import '../../export.dart';

final locationPermissionProvider = ChangeNotifierProvider.autoDispose<LocationPermissionNotifier>((ref) => LocationPermissionNotifier());

class LocationPermissionNotifier extends ChangeNotifier {
  void skip(BuildContext context, WidgetRef ref) async {
    var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ConfirmationDialog());
    if (result == false || result == null) {
      return;
    }
    ref.read(splashProvider.notifier).redirections(context, false);
  }

  void continueTab(BuildContext context, WidgetRef ref) async {
    var result = await Geolocator.requestPermission();
    if (result == LocationPermission.deniedForever) {
      await openAppSettings();
    }
    ref.read(splashProvider.notifier).redirections(context, false);
  }
}
