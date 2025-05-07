import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/services/translations/locale_keys.g.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';
import '../view/umera/safa_marwa_home.dart';
import 'button.dart';
import 'custom_image.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 85,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), border: Border.all(color: CColors.primary)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [BottomNavItem(icon: 'assets/svg/user.svg', title: 'Profile'), BottomNavItem(icon: 'assets/svg/supplications.svg', title: 'Supplications')],
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [BottomNavItem(icon: 'assets/svg/prayer.svg', title: 'Prayer'), BottomNavItem(icon: 'assets/svg/settings.svg', title: 'Settings')],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: CButton(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SafaMarwaHomePage())),
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
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({super.key, required this.icon, required this.title});
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [CustomImage(path: icon, imageType: ImageType.svg, height: 18, width: 18, fit: BoxFit.scaleDown), Text(title, style: CTextStyle.w400(color: CColors.deepTeal, fontSize: 9))],
    );
  }
}
