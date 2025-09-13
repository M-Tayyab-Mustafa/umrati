import '../../../../export.dart';

class MeeqaatThreeTasksPage extends ConsumerStatefulWidget {
  const MeeqaatThreeTasksPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeeqaatThreeTasksPageState();
}

class _MeeqaatThreeTasksPageState extends ConsumerState<MeeqaatThreeTasksPage> {
  @override
  void initState() {
    super.initState();
    ref.read(meeqaatThreeTasksProvider.notifier).context = context;
    ref.read(meeqaatThreeTasksProvider.notifier).ref = ref;
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(meeqaatThreeTasksProvider);
    return Background(
      title: LocaleKeys.do_these_5_ihram_related_tasks.tr(),
      backgroundType: BackgroundType.logoWithSkip,
      isSkipLoading: provider.isLoading,
      titleMargin: EdgeInsets.only(top: 50, bottom: 40),
      showEmblem: false,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06, bottom: 85),
      onSkipTap: provider.skip,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text(LocaleKeys.three_tasks_at_meeqaat.tr(), style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal))),
            Center(child: Text(LocaleKeys.these_3_tasks_can_be_done_even_before_meeqaat.tr(), style: CTextStyle.w400(fontSize: 14, color: CColors.primary))),
            CheckBoxCard(
              margin: EdgeInsets.symmetric(vertical: 20),
              title: LocaleKeys.two_nafl_prayers.tr(),
              isSelected: provider.isTwoNafiPrayersChecked,
              onTap: provider.updateTwoNafiPrayersChecked,
            ),
            CheckBoxCard(title: LocaleKeys.intention_niyyah.tr(), isSelected: provider.isIntentionChecked, onTap: provider.updateIntentionChecked),
            CheckBoxCard(margin: EdgeInsets.symmetric(vertical: 20), title: LocaleKeys.talbiyah.tr(), isSelected: provider.isTalbiyahChecked, onTap: provider.updateTalbiyahChecked),
            CButton(isLoading: provider.isLoading, onTap: provider.tasksDone, margin: EdgeInsets.only(top: 40), title: LocaleKeys.tasks_done.tr(), titleWithIcon: true),
          ],
        ),
      ),
    );
  }
}
