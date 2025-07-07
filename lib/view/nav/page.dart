import '../../export.dart';

class BottomNavigationPage extends ConsumerWidget {
  const BottomNavigationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(bottomNavProvider);
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: provider.logoAlign,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06),
      child: Column(
        children: [
          Expanded(child: provider.child),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 85,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
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
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                BottomNavItem(
                                  onTap: () => provider.onBottomNavTap.call(BottomNavTabs.profile),
                                  isSelected: BottomNavTabs.profile == provider.selectedTab,
                                  icon: 'assets/svg/bottom_nav/profile.svg',
                                  title: LocaleKeys.profile.tr(),
                                ),
                                BottomNavItem(
                                  onTap: () => provider.onBottomNavTap.call(BottomNavTabs.umra),
                                  isSelected: BottomNavTabs.umra == provider.selectedTab,
                                  icon: 'assets/svg/bottom_nav/supplications.svg',
                                  title: LocaleKeys.umra.tr(),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                BottomNavItem(
                                  onTap: () => provider.onBottomNavTap.call(BottomNavTabs.ziarat),
                                  isSelected: BottomNavTabs.ziarat == provider.selectedTab,
                                  icon: 'assets/svg/bottom_nav/ziarat.svg',
                                  title: LocaleKeys.ziarat.tr(),
                                ),
                                BottomNavItem(
                                  onTap: () => provider.onBottomNavTap.call(BottomNavTabs.settings),
                                  isSelected: BottomNavTabs.settings == provider.selectedTab,
                                  icon: 'assets/svg/bottom_nav/settings.svg',
                                  title: LocaleKeys.settings.tr(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: CButton(
                      onTap: () => provider.onBottomNavTap.call(BottomNavTabs.home),
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(bottom: 15),
                      height: 70,
                      width: 70,
                      borderColor: Colors.transparent,
                      shadows: [],
                      gradient: CColors.solidButtonGradient,
                      borderRadius: BorderRadius.circular(9999),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomImage(path: 'assets/svg/bottom_nav/home.svg', imageType: ImageType.svg, height: 25, width: 25, fit: BoxFit.fill),
                            Text(LocaleKeys.home.tr(), style: CTextStyle.w500(color: Colors.white, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
