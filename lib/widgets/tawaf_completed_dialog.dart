import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../utils/helper/constants.dart';
import '../utils/services/translations/locale_keys.g.dart';
import '../utils/theme/colors.dart';
import '../utils/theme/text_style.dart';
import 'button.dart';
import 'custom_image.dart';

class TawafCompletionDialog extends StatelessWidget {
  const TawafCompletionDialog({super.key});

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: screenSize.width * 0.67,
              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.0),
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenSize.height * 0.05),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
                          child: Text(LocaleKeys.now_please_pray_while_facing_kibla.tr(), style: CTextStyle.w900(fontSize: 20, color: CColors.deepTeal), textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                  CButton(title: 'Continue', titleWithIcon: true, onTap: () => Navigator.pop(dialogContext), margin: EdgeInsets.only(bottom: 30)),
                ],
              ),
            ),
          ),
          Align(alignment: Alignment(0, -0.3), child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80)),
        ],
      ),
    );
  }
}
