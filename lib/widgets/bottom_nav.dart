import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/helper/constants.dart';
import '../utils/services/translations/locale_keys.g.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';
import 'bottom_nav_item.dart';
import 'button.dart';
import 'custom_image.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, this.onBottomNavTap, required this.selectedTab, required this.child});
  final ValueChanged<BottomNavTabs>? onBottomNavTap;
  final BottomNavTabs selectedTab;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child),
        SizedBox(
          height: 85,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
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
                              onTap: () => onBottomNavTap?.call(BottomNavTabs.profile),
                              isSelected: BottomNavTabs.profile == selectedTab,
                              icon: 'assets/svg/user.svg',
                              title: LocaleKeys.profile.tr(),
                            ),
                            BottomNavItem(
                              onTap: () => onBottomNavTap?.call(BottomNavTabs.umera),
                              isSelected: BottomNavTabs.umera == selectedTab,
                              icon: 'assets/svg/umera.svg',
                              title: LocaleKeys.umera.tr(),
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
                              onTap: () => onBottomNavTap?.call(BottomNavTabs.ziarat),
                              isSelected: BottomNavTabs.ziarat == selectedTab,
                              icon: 'assets/svg/ziarat.svg',
                              title: LocaleKeys.ziarat.tr(),
                            ),
                            BottomNavItem(
                              onTap: () => onBottomNavTap?.call(BottomNavTabs.settings),
                              isSelected: BottomNavTabs.settings == selectedTab,
                              icon: 'assets/svg/settings.svg',
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
                  onTap: () => onBottomNavTap?.call(BottomNavTabs.more),
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
                        CustomImage(path: 'assets/svg/more.svg', imageType: ImageType.svg, height: 25, width: 25, fit: BoxFit.fill),
                        Text(LocaleKeys.more.tr(), style: CTextStyle.w500(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
