import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/check_box_card.dart';
import '../../widgets/custom_image.dart';
import 'umra_completed.dart';

class SaiCompletionPage extends StatefulWidget {
  const SaiCompletionPage({super.key});

  @override
  State<SaiCompletionPage> createState() => _SaiCompleteStationPage();
}

class _SaiCompleteStationPage extends State<SaiCompletionPage> {
  @override
  Widget build(BuildContext context) {
    return Background(
      showEmblem: false,
      showBottomNav: true,
      backgroundType: BackgroundType.logo,
      logoAlign: MainAxisAlignment.center,
      margin: EdgeInsets.only(top: 60, left: 30, right: 30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: constraints.maxHeight * 0.33,
                width: constraints.maxHeight * 0.33,
                decoration: BoxDecoration(
                  gradient: CColors.trackingGradient,
                  shape: BoxShape.circle,
                  border: Border.all(color: CColors.primary),
                  boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
                ),
                child: Center(
                  child: Container(
                    height: constraints.maxHeight * 0.28,
                    width: constraints.maxHeight * 0.28,
                    decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomImage(path: 'assets/svg/complete_check.svg', imageType: ImageType.svg, height: 60, width: 60),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(LocaleKeys.your_sai_has_completed.tr(), style: CTextStyle.w800(fontSize: 20, color: Colors.white), textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              CheckBoxCard(
                title: LocaleKeys.shave_the_head.tr(),
                isSelected: false,
                onTap: () {},
                child: Text(LocaleKeys.shave_the_head_description.tr(), style: CTextStyle.w400(color: CColors.primary, height: 1.2)),
              ),

              CButton(title: LocaleKeys.continued.tr(), titleWithIcon: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UmraCompleted()))),
            ],
          );
        },
      ),
    );
  }
}
