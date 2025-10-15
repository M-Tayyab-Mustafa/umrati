import '../../../../export.dart';

class SaiCompletionPage extends ConsumerWidget {
  const SaiCompletionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(umrahProvider);
    return Background(
      logoAlign: Alignment.center,
      backgroundType: BackgroundType.logo,
      title: '',
      titleType: TitleType.backArrow,
      margin: SizeConfig.only(top: kToolbarHeight * 0.5, left: 16, right: 16),
      showEmblem: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: SizeConfig.w(280),
            width: SizeConfig.w(280),
            padding: SizeConfig.all(16),
            decoration: BoxDecoration(
              gradient: CColors.trackingGradient,
              shape: BoxShape.circle,
              border: Border.all(color: CColors.primary),
              boxShadow: [BoxShadow(color: Color(0xFF1A172D).withValues(alpha: 0.01), blurRadius: 5, offset: Offset(0, 5))],
            ),
            child: Container(
              alignment: Alignment.center,
              padding: SizeConfig.all(16),
              decoration: BoxDecoration(gradient: CColors.solidButtonGradient, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImage(path: 'assets/svg/complete_check.svg', imageType: ImageType.svg, size: SizeConfig.w(80)),
                  Padding(
                    padding: SizeConfig.only(top: 10),
                    child: Text(LocaleKeys.your_sai_has_completed.tr(), style: CTextStyle.w800(fontSize: 22, color: Colors.white), textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ),
          CheckBoxCard(
            title: provider.user?.gender == Gender.female.name ? LocaleKeys.perform_taqsir.tr() : LocaleKeys.shave_the_head.tr(),
            isSelected: provider.isShavedHead,
            onTap: provider.toggleShaveTheHead,
            child: Text(
              provider.user?.gender == Gender.female.name ? LocaleKeys.trim_a_small_portion.tr() : LocaleKeys.shave_the_head_description.tr(),
              style: CTextStyle.w400(color: CColors.primary, fontSize: 14),
            ),
          ),
          CButton(isLoading: provider.isLoading, title: LocaleKeys.continued.tr(), titleWithIcon: true, onTap: ref.read(umrahProvider).umrahCompleted),
        ],
      ),
    );
  }
}
