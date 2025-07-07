import '../../../export.dart';

final homeProvider = ChangeNotifierProvider.autoDispose<HomeNotifier>((ref) => HomeNotifier());

class HomeNotifier extends ChangeNotifier {
  void onumraTap({required BuildContext context, required WidgetRef ref}) async {
    ref.watch(tawafProvider).isFromumra = true;
    ref.watch(bottomNavProvider).onBottomNavTap(BottomNavTabs.umra);
  }

  void onTawafTap({required BuildContext context, required WidgetRef ref}) async {
    ref.watch(tawafProvider).isFromumra = false;
    ref.watch(bottomNavProvider).onBottomNavTap(BottomNavTabs.umra);
  }

  void onZiaratTap({required BuildContext context, required WidgetRef ref}) async {
    ref.watch(bottomNavProvider).onBottomNavTap(BottomNavTabs.ziarat);
  }
}
