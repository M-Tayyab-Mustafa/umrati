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
      titleMargin: EdgeInsets.only(top: 50, bottom: 40),
      titleType: TitleType.backArrow,
      showEmblem: false,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06, bottom: 85),
      onSkipTap: provider.skip,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Text(LocaleKeys.two_before_meeqaat.tr(), style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal))),
            CheckBoxCard(
              onTap: ref.read(meeqaatTwoTasksProvider).updateCleanlinessChecked,
              margin: EdgeInsets.only(top: 20),
              title: LocaleKeys.cleanliness.tr(),
              isSelected: provider.isCleanlinessChecked,
            ),
            CheckBoxCard(
              margin: EdgeInsets.only(top: 20, bottom: 40),
              title: provider.user?.gender == Gender.male.name ? LocaleKeys.ihram.tr() : LocaleKeys.wear_abaya.tr(),
              isSelected: provider.isIhramChecked,
              onTap: ref.read(meeqaatTwoTasksProvider).updateIhramChecked,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            provider.user?.gender == Gender.male.name
                                ? '${LocaleKeys.take_a_bath_ghusl_or_perform_ablution_wudu_and_then_wear_the_ihram.tr()}\n'
                                : '${LocaleKeys.take_a_bath_ghusl_or_perform_ablution_wudu_and_then_wear_the_abaya.tr()}\n',
                        style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: provider.showIhramTutorial,
                          child: Text(
                            provider.user?.gender == Gender.male.name ? LocaleKeys.ihram_tutorial_pics.tr() : LocaleKeys.abaya_tutorial_pics.tr(),
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
    );
  }
}
