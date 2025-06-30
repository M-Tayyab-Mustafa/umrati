import '../../../export.dart';
import '../../../view/nav/home/umera/tawaf.dart';

final homeProvider = ChangeNotifierProvider.autoDispose<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  UserModel? user;
  initialization() async {
    user = await LocalStorageManager.getUser();
  }

  void onUmeraTap({required BuildContext context, required WidgetRef ref}) async {
    user ??= await LocalStorageManager.getUser();
    if ((int.tryParse(user!.tawaf_circle_count) ?? 0) > 0) {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlreadyDialog(isDoingUmera: true));
      if (result == null) return;
      if (result == true) {
        ref.watch(tawafProvider).isInTawaf = true;
        if ((int.tryParse(user!.tawaf_circle_count) ?? 0) >= 7) {
          ref.watch(tawafProvider).showSafaMarwa = true;
        }
      } else {
        await LocalStorageManager.saveUser(user!.copyWith(tawaf_circle_count: '0'));
      }
    }
    ref.watch(tawafProvider).isFromUmera = true;
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const StartTawafPage()));
    user = await LocalStorageManager.getUser();
  }

  void onTawafTap({required BuildContext context, required WidgetRef ref}) async {
    user ??= await LocalStorageManager.getUser();
    if ((int.tryParse(user!.tawaf_circle_count) ?? 0) > 0 && (int.tryParse(user!.tawaf_circle_count) ?? 0) < 7) {
      var result = await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlreadyDialog(isDoingUmera: true));
      if (result == null) return;
      if (result == true) {
        ref.watch(tawafProvider).isInTawaf = true;
      } else {
        await LocalStorageManager.saveUser(user!.copyWith(tawaf_circle_count: '0'));
      }
    } else if ((int.tryParse(user!.tawaf_circle_count) ?? 0) >= 7) {
      await LocalStorageManager.saveUser(user!.copyWith(tawaf_circle_count: '0'));
    }
    ref.watch(tawafProvider).isFromUmera = false;
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const StartTawafPage()));
    user = await LocalStorageManager.getUser();
  }

  void onZiaratTap({required BuildContext context, required WidgetRef ref}) async {
    user ??= await LocalStorageManager.getUser();
  }
}
