import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../button.dart';
import '../custom_image.dart';

class AlreadyDialog extends StatelessWidget {
  const AlreadyDialog({super.key, required this.isDoingUmera});
  final bool isDoingUmera;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: screenSize.height * 0.35,
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
                    child: Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.05, left: screenSize.width * 0.1, right: screenSize.width * 0.1),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                isDoingUmera ? LocaleKeys.already_in_umera.tr() : LocaleKeys.already_in_ziarats.tr(),
                                style: CTextStyle.w900(fontSize: 16, color: CColors.deepTeal),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: CButton(
                            height: 50,
                            title: LocaleKeys.start_new.tr(),
                            onTap: () => Navigator.pop(dialogContext, false),
                            margin: EdgeInsets.only(bottom: 30),
                            style: CTextStyle.w400(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 16),
                          child: CButton(
                            height: 50,
                            title: LocaleKeys.continued.tr(),
                            onTap: () => Navigator.pop(dialogContext, true),
                            margin: EdgeInsets.only(bottom: 30),
                            style: CTextStyle.w400(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: screenSize.height * 0.275, left: (screenSize.width * 0.5) - 40, child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80)),
        ],
      ),
    );
  }
}
