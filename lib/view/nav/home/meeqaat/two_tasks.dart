import '../../../../export.dart';

class MeeqaatTwoTasksPage extends ConsumerWidget {
  const MeeqaatTwoTasksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(meeqaatTwoTasksProvider);
    ref.read(meeqaatTwoTasksProvider.notifier).context = context;
    ref.read(meeqaatTwoTasksProvider.notifier).ref = ref;
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
          children: [
            Center(child: Text(LocaleKeys.two_before_meeqaat.tr(), style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal))),
            CheckBoxCard(
              onTap: ref.read(meeqaatTwoTasksProvider).updateCleanlinessChecked,
              margin: EdgeInsets.only(top: 20),
              title: LocaleKeys.cleanliness.tr(),
              isSelected: ref.watch(meeqaatTwoTasksProvider).isCleanlinessChecked,
            ),
            CheckBoxCard(
              margin: EdgeInsets.only(top: 20, bottom: 40),
              title: LocaleKeys.ihram.tr(),
              isSelected: ref.watch(meeqaatTwoTasksProvider).isIhramChecked,
              onTap: ref.read(meeqaatTwoTasksProvider).updateIhramChecked,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${LocaleKeys.take_a_bath_ghusl_or_perform_ablution_wudu_and_then_wear_the_ihram.tr()}\n', style: CTextStyle.w600(fontSize: 14, color: CColors.deepTeal)),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: provider.showIhramTutorial,
                          child: Text(LocaleKeys.ihram_tutorial_pics.tr(), style: CTextStyle.w600(fontSize: 14, color: CColors.primary, decoration: TextDecoration.underline, height: 0.8)),
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
