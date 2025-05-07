import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controller/nav/umera/tawaf_provider.dart';
import '../../../utils/helper/constants.dart';
import '../../../utils/services/translations/locale_keys.g.dart';
import '../../../utils/theme/colors.dart';
import '../../../utils/theme/text_style.dart';
import '../../../widgets/button.dart';
import '../../../widgets/custom_image.dart';

class UmraCompleted extends StatelessWidget {
  const UmraCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: SizedBox(
            height: screenSize.height * 0.35,
            child: Stack(
              children: [
                CustomImage(path: 'assets/svg/kaba_image.svg', imageType: ImageType.svg, height: screenSize.height * 0.28, fit: BoxFit.fill),
                Align(
                  alignment: Alignment(0, 1),
                  child: Container(
                    height: screenSize.height * 0.28,
                    width: screenSize.width * 0.28,
                    decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
                    child: Center(child: Icon(Icons.check, size: screenSize.height * 0.08, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(LocaleKeys.congratulations.tr(), style: CTextStyle.w800(fontSize: 18)),
              Padding(padding: const EdgeInsets.only(bottom: 10, top: 30), child: Text(LocaleKeys.your_umra_has_been_completed.tr(), style: CTextStyle.w600(fontSize: 20, color: CColors.primary))),
              Text(LocaleKeys.may_allah_accept_your_umra_ameen.tr(), style: CTextStyle.w600(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center),
            ],
          ),
        ),
        Consumer(
          builder: (context, ref, child) => CButton(onTap: ref.read(tawafProvider).goToHome, margin: const EdgeInsets.only(bottom: 60), title: LocaleKeys.go_to_home_screen.tr(), titleWithIcon: true),
        ),
      ],
    );
  }
}
