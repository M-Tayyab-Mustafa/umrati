import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/meeqaat/two_tasks_provider.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/check_box_card.dart';

class MeeqaatTwoTasksPage extends ConsumerWidget {
  const MeeqaatTwoTasksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(meeqaatTwoTasksProvider);

    return Background(
      title: LocaleKeys.do_these_5_ihram_related_tasks.tr(),
      backgroundType: BackgroundType.logoWithSkip,
      titleAlignment: Alignment.center,
      titleMargin: EdgeInsets.only(top: 50, bottom: 40),
      onSkipTap: () => provider.skip(context),
      child: Column(
        children: [
          Center(child: Text(LocaleKeys.two_before_meeqaat.tr(), style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal))),
          CheckBoxCard(margin: EdgeInsets.only(top: 20), title: LocaleKeys.cleanliness.tr(), isSelected: false, onTap: () {}),
          CheckBoxCard(
            margin: EdgeInsets.only(top: 20, bottom: 40),
            title: LocaleKeys.ihram.tr(),
            isSelected: false,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: LocaleKeys.take_a_bath_ghusl_or_perform_ablution_wudu_and_then_wear_the_ihram.tr(), style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal)),
                    WidgetSpan(
                      child: Text('\n${LocaleKeys.ihram_tutorial_pics.tr()}', style: CTextStyle.w600(fontSize: 14, color: CColors.primary, decoration: TextDecoration.underline, height: 0.8)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CButton(isLoading: provider.isConfirmingMeeqaat, onTap: () => provider.moveToThreeOtherTasks(context), title: LocaleKeys.move_to_3_other_tasks.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
