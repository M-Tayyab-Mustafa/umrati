part of 'page.dart';

class ChooseDestinations extends ConsumerWidget {
  const ChooseDestinations({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaraatProvider);
    var isAutoSelected = provider.selectedDestinationsCreationOption == ZiaraatDestinationsCreationOptions.auto;
    var isManualSelected = provider.selectedDestinationsCreationOption == ZiaraatDestinationsCreationOptions.manual;
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      title: LocaleKeys.please_select_one_option_to_continue_your_ziaraat.tr(),
      titleType: TitleType.backArrow,
      titleMargin: ScaledEdgeInsets.symmetric(vertical: kToolbarHeight * 0.5),
      margin: ScaledEdgeInsets.only(top: kToolbarHeight * 0.5, left: 16, right: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BasicCard(
              height: 130.pr,
              width: SizeConfig.mediaQuery.size.width,
              onTap: () => ref.read(ziaraatProvider.notifier).updateSelectedDestinationsCreationOption(ZiaraatDestinationsCreationOptions.auto),
              padding: ScaledEdgeInsets.all(20),
              borderColor: isAutoSelected ? null : CColors.greyShade2,
              boxShadow: isAutoSelected ? null : [],
              borderWidth: 3.pr,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.auto_generate.tr(), style: CTextStyle.w400(fontSize: 22, color: isAutoSelected ? CColors.primary : CColors.greyShade2)),
                  Text(LocaleKeys.auto_generate_description.tr(), style: CTextStyle.w400(fontSize: 14, color: isAutoSelected ? CColors.primary : CColors.greyShade2)),
                ],
              ),
            ),
            BasicCard(
              height: 130.pr,
              width: SizeConfig.mediaQuery.size.width,
              onTap: () => ref.read(ziaraatProvider.notifier).updateSelectedDestinationsCreationOption(ZiaraatDestinationsCreationOptions.manual),
              margin: ScaledEdgeInsets.symmetric(vertical: 30),
              padding: ScaledEdgeInsets.all(20),
              borderColor: isManualSelected ? CColors.primary : CColors.greyShade2,
              boxShadow: isManualSelected ? null : [],
              borderWidth: 3.pr,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.manual_selection.tr(), style: CTextStyle.w400(fontSize: 22, color: isManualSelected ? CColors.primary : CColors.greyShade2)),
                  Text(LocaleKeys.manual_selection_description.tr(), style: CTextStyle.w400(fontSize: 14, color: isManualSelected ? CColors.primary : CColors.greyShade2)),
                ],
              ),
            ),
            if (ref.watch(ziaraatProvider).selectedDestinationsCreationOption != null) CButton(margin: ScaledEdgeInsets.only(top: 64), isLoading: provider.isLoading, onTap: provider.generateZiaraat, title: LocaleKeys.proceed_forward.tr()),
          ],
        ),
      ),
    );
  }
}
