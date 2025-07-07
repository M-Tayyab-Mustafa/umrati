import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../controller/nav/umra/umra_provider.dart';
import '../../../../utils/services/translations/locale_keys.g.dart';
import '../../../../utils/theme/colors.dart';
import '../../../../utils/theme/text_style.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/check_box_card.dart';
import '../../../../widgets/custom_image.dart';

class SaiCompletionPage extends ConsumerWidget {
  const SaiCompletionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(tawafProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: constraints.maxHeight * 0.4,
              width: constraints.maxHeight * 0.4,
              alignment: Alignment.center,
              padding: EdgeInsets.all(constraints.maxHeight * 0.02),
              decoration: BoxDecoration(
                gradient: CColors.trackingGradient,
                shape: BoxShape.circle,
                border: Border.all(color: CColors.primary),
                boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(constraints.maxHeight * 0.04),
                decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImage(path: 'assets/svg/complete_check.svg', imageType: ImageType.svg, height: constraints.maxHeight * 0.14, width: constraints.maxHeight * 0.14),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(LocaleKeys.your_sai_has_completed.tr(), style: CTextStyle.w800(fontSize: 22, color: Colors.white), textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
            CheckBoxCard(
              title: LocaleKeys.shave_the_head.tr(),
              isSelected: provider.isShavedHead,
              onTap: provider.toggleShaveTheHead,
              child: Text(LocaleKeys.shave_the_head_description.tr(), style: CTextStyle.w400(color: CColors.primary, height: 1.2)),
            ),
            CButton(title: LocaleKeys.continued.tr(), titleWithIcon: true, onTap: ref.read(tawafProvider).umraCompleted),
          ],
        );
      },
    );
  }
}
