import '../../../../export.dart';

class MeeqaatTwoTasksPage extends ConsumerStatefulWidget {
  const MeeqaatTwoTasksPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MeeqaatTwoTasksPageState();
}

class _MeeqaatTwoTasksPageState extends ConsumerState<MeeqaatTwoTasksPage> {
  @override
  void initState() {
    super.initState();
    ref.read(meeqaatTwoTasksProvider.notifier).context = context;
    ref.read(meeqaatTwoTasksProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(meeqaatTwoTasksProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(meeqaatTwoTasksProvider);
    return Background(
      title: LocaleKeys.do_these_5_ihram_related_tasks.tr(),
      backgroundType: BackgroundType.logoWithSkip,
      isSkipLoading: provider.isLoading,
      titleType: TitleType.backArrow,
      showEmblem: false,
      margin: SizeConfig.only(top: kToolbarHeight * 0.8),
      onSkipTap: provider.skip,
      child: SingleChildScrollView(
        child: Padding(
          padding: SizeConfig.symmetric(horizontal: 16),
          child: Column(
            children: [
              Padding(padding: SizeConfig.only(top: 20), child: Center(child: Text(LocaleKeys.two_before_meeqaat.tr(), style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal)))),
              CheckBoxCard(
                margin: SizeConfig.symmetric(vertical: 20),
                onTap: ref.read(meeqaatTwoTasksProvider).updateCleanlinessChecked,
                title: LocaleKeys.cleanliness.tr(),
                isSelected: provider.isCleanlinessChecked,
              ),
              CheckBoxCard(
                margin: SizeConfig.only(bottom: 40),
                title: provider.user?.gender == Gender.female.name ? LocaleKeys.wear_abaya.tr() : LocaleKeys.ihram.tr(),
                isSelected: provider.isIhramChecked,
                onTap: ref.read(meeqaatTwoTasksProvider).updateIhramChecked,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              provider.user?.gender == Gender.female.name
                                  ? '${LocaleKeys.take_a_bath_ghusl_or_perform_ablution_wudu_and_then_wear_the_abaya.tr()}\n'
                                  : '${LocaleKeys.take_a_bath_ghusl_or_perform_ablution_wudu_and_then_wear_the_ihram.tr()}\n',
                          style: CTextStyle.w600(fontSize: 12, color: CColors.deepTeal),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: provider.showIhramTutorial,
                            child: Text(
                              provider.user?.gender == Gender.female.name ? LocaleKeys.abaya_tutorial_pics.tr() : LocaleKeys.ihram_tutorial_pics.tr(),
                              style: CTextStyle.w600(fontSize: 14, color: CColors.primary, decoration: TextDecoration.underline, height: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CButton(isLoading: provider.isLoading, onTap: provider.moveToThreeOtherTasks, title: LocaleKeys.move_to_3_other_tasks.tr(), titleWithIcon: true),
            ],
          ),
        ),
      ),
    );
  }
}
