import '../../export.dart';

class BottomNavigationPage extends ConsumerWidget {
  const BottomNavigationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(bottomNavProvider);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            provider.child,
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    border: Border.all(color: CColors.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: BottomNavItem(
                          onTap: () => provider.onBottomNavTap.call(BottomNavTabs.home),
                          isSelected: BottomNavTabs.home == provider.selectedTab,
                          icon: 'assets/svg/bottom_nav/home.svg',
                          title: LocaleKeys.home.tr(),
                        ),
                      ),
                      Expanded(
                        child: BottomNavItem(
                          onTap: () => provider.onBottomNavTap.call(BottomNavTabs.profile),
                          isSelected: BottomNavTabs.profile == provider.selectedTab,
                          icon: 'assets/svg/bottom_nav/profile.svg',
                          title: LocaleKeys.profile.tr(),
                        ),
                      ),
                      Expanded(
                        child: BottomNavItem(
                          onTap: () => provider.onBottomNavTap.call(BottomNavTabs.askMufti),
                          isSelected: BottomNavTabs.askMufti == provider.selectedTab,
                          icon: 'assets/svg/bottom_nav/ask_mufti.svg',
                          title: LocaleKeys.ask_mufti.tr(),
                        ),
                      ),
                      Expanded(
                        child: BottomNavItem(
                          onTap: () => provider.onBottomNavTap.call(BottomNavTabs.settings),
                          isSelected: BottomNavTabs.settings == provider.selectedTab,
                          icon: 'assets/svg/bottom_nav/settings.svg',
                          title: LocaleKeys.settings.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
