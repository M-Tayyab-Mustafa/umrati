import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/meeqaat/three_tasks_provider.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/meeqaat_card.dart';

class MeeqaatThreeTasksPage extends ConsumerWidget {
  const MeeqaatThreeTasksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(meeqaatThreeTasksProvider);
    return Background(
      onSkipTap: () => provider.skip(context),
      title: LocaleKeys.do_these_5_ihram_related_tasks.tr(),
      backgroundType: BackgroundType.logoWithSkip,
      titleAlignment: Alignment.center,
      titleMargin: EdgeInsets.only(top: 50, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Text(LocaleKeys.three_tasks_at_meeqaat.tr(), style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal))),
          Center(child: Text(LocaleKeys.these_3_tasks_can_be_done_even_before_meeqaat.tr(), style: CTextStyle.w400(fontSize: 14, color: CColors.primary))),
          MeeqaatCard(margin: EdgeInsets.symmetric(vertical: 20), title: LocaleKeys.two_nafl_prayers.tr(), isSelected: false, onTap: () {}),
          MeeqaatCard(title: LocaleKeys.intention_niyyah.tr(), isSelected: false, onTap: () {}),
          MeeqaatCard(margin: EdgeInsets.symmetric(vertical: 20), title: LocaleKeys.talbiyah.tr(), isSelected: false, onTap: () {}),
          CButton(isLoading: provider.isConfirmingMeeqaat, onTap: () => provider.tasksDone(context), margin: EdgeInsets.only(top: 30), title: LocaleKeys.tasks_done.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
