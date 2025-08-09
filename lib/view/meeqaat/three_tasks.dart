import '../../export.dart';

class MeeqaatThreeTasksPage extends ConsumerWidget {
  const MeeqaatThreeTasksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(meeqaatThreeTasksProvider);
    return Background(
      margin: EdgeInsets.only(top: screenSize.height * 0.13, left: 30, right: 30),
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
          CheckBoxCard(margin: EdgeInsets.symmetric(vertical: 20), title: LocaleKeys.two_nafl_prayers.tr(), isSelected: provider.isTwoNafiPrayersChecked, onTap: provider.updateTwoNafiPrayersChecked),
          CheckBoxCard(title: LocaleKeys.intention_niyyah.tr(), isSelected: provider.isIntentionChecked, onTap: provider.updateIntentionChecked),
          CheckBoxCard(margin: EdgeInsets.symmetric(vertical: 20), title: LocaleKeys.talbiyah.tr(), isSelected: provider.isTalbiyahChecked, onTap: provider.updateTalbiyahChecked),
          CButton(onTap: () => provider.tasksDone(context), margin: EdgeInsets.only(top: 30), title: LocaleKeys.tasks_done.tr(), titleWithIcon: true),
        ],
      ),
    );
  }
}
