import '../../export.dart';

class BottomNavigationPage extends ConsumerWidget {
  const BottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(bottomNavProvider);
    return Scaffold(
      body: PopScope(
        canPop: provider.canPop,
        onPopInvokedWithResult: provider.onPopInvokedWithResult,
        child: SafeArea(top: false, child: Stack(children: [provider.child, RepaintBoundary(child: const Align(alignment: Alignment.bottomCenter, child: _BottomNavBar()))])),
      ),
    );
  }
}

class _BottomNavBar extends ConsumerWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(bottomNavProvider);
    return Padding(
      padding: context.edgeInsets(horizontal: 16),
      child: Container(
        height: context.h(50),
        decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), border: Border.all(color: CColors.primary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: BottomNavItem(onTap: () => provider.onBottomNavTap(context, BottomNavTabs.home), isSelected: provider.selectedTab == BottomNavTabs.home, icon: 'assets/svg/bottom_nav/home.svg', title: LocaleKeys.home.tr())),
            Expanded(child: BottomNavItem(onTap: () => provider.onBottomNavTap(context, BottomNavTabs.profile), isSelected: provider.selectedTab == BottomNavTabs.profile, icon: 'assets/svg/bottom_nav/profile.svg', title: LocaleKeys.profile.tr())),
            Expanded(
              child: BottomNavItem(onTap: () => provider.onBottomNavTap(context, BottomNavTabs.askMufti), isSelected: provider.selectedTab == BottomNavTabs.askMufti, icon: 'assets/svg/bottom_nav/ask_mufti.svg', title: LocaleKeys.ask_mufti.tr()),
            ),
            Expanded(
              child: BottomNavItem(onTap: () => provider.onBottomNavTap(context, BottomNavTabs.settings), isSelected: provider.selectedTab == BottomNavTabs.settings, icon: 'assets/svg/bottom_nav/settings.svg', title: LocaleKeys.settings.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
