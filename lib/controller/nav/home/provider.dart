import '../../../export.dart';

final homeProvider = ChangeNotifierProvider.autoDispose<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  void onUmraTap({required BuildContext context, required WidgetRef ref}) async {
    ref.watch(tawafProvider).isFromUmra = true;
    ref.watch(bottomNavProvider).onBottomNavTap(BottomNavTabs.umra);
  }

  void onTawafTap({required BuildContext context, required WidgetRef ref}) async {
    ref.watch(tawafProvider).isFromUmra = false;
    ref.watch(bottomNavProvider).onBottomNavTap(BottomNavTabs.umra);
  }

  void onZiaratTap({required BuildContext context, required WidgetRef ref}) async {
    ref.watch(bottomNavProvider).onBottomNavTap(BottomNavTabs.ziarat);
  }
}
