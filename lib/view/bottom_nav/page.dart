import '../../export.dart';

class BottomNavigationPage extends ConsumerStatefulWidget {
  const BottomNavigationPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavigationPageState();
}

class _BottomNavigationPageState extends ConsumerState<BottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(bottomNavProvider);
    return Scaffold(
      body: PopScope(
        canPop: provider.canPop,
        onPopInvokedWithResult: provider.onPopInvokedWithResult,
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              provider.child,
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: context.edgeInsets(horizontal: 16),
                  child: Container(
                    height: context.h(50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border: Border.all(color: CColors.primary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: BottomNavItem(
                            onTap:
                                () => provider.onBottomNavTap.call(
                                  context,
                                  BottomNavTabs.home,
                                ),
                            isSelected:
                                BottomNavTabs.home == provider.selectedTab,
                            icon: 'assets/svg/bottom_nav/home.svg',
                            title: LocaleKeys.home.tr(),
                          ),
                        ),
                        Expanded(
                          child: BottomNavItem(
                            onTap:
                                () => provider.onBottomNavTap.call(
                                  context,
                                  BottomNavTabs.profile,
                                ),
                            isSelected:
                                BottomNavTabs.profile == provider.selectedTab,
                            icon: 'assets/svg/bottom_nav/profile.svg',
                            title: LocaleKeys.profile.tr(),
                          ),
                        ),
                        Expanded(
                          child: BottomNavItem(
                            onTap:
                                () => provider.onBottomNavTap.call(
                                  context,
                                  BottomNavTabs.askMufti,
                                ),
                            isSelected:
                                BottomNavTabs.askMufti == provider.selectedTab,
                            icon: 'assets/svg/bottom_nav/ask_mufti.svg',
                            title: LocaleKeys.ask_mufti.tr(),
                          ),
                        ),
                        Expanded(
                          child: BottomNavItem(
                            onTap:
                                () => provider.onBottomNavTap.call(
                                  context,
                                  BottomNavTabs.settings,
                                ),
                            isSelected:
                                BottomNavTabs.settings == provider.selectedTab,
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
      ),
    );
  }
}
