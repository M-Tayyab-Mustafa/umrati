import '../../../../export.dart';

class SaiCompletionPage extends ConsumerWidget {
  const SaiCompletionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(umraProvider);
    return Background(
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logo,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06, bottom: 85),
      showEmblem: false,
      child: LayoutBuilder(
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
                title: provider.user?.gender == Gender.female.name ? LocaleKeys.in_low_voice.tr() : LocaleKeys.shave_the_head.tr(),
                isSelected: provider.isShavedHead,
                onTap: provider.toggleShaveTheHead,
                child: Text(
                  provider.user?.gender == Gender.female.name ? LocaleKeys.in_low_voice.tr() : LocaleKeys.shave_the_head_description.tr(),
                  style: CTextStyle.w400(color: CColors.primary, height: 1.2),
                ),
              ),
              CButton(isLoading: provider.isLoading, title: LocaleKeys.continued.tr(), titleWithIcon: true, onTap: ref.read(umraProvider).umraCompleted),
            ],
          );
        },
      ),
    );
  }
}
