part of 'page.dart';

class ChooseDestinations extends ConsumerWidget {
  const ChooseDestinations({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaratProvider);
    var isAutoSelected = provider.selectedDestinationsCreationOption == ZiaratDestinationsCreationOptions.auto;
    var isManualSelected = provider.selectedDestinationsCreationOption == ZiaratDestinationsCreationOptions.manual;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                CustomImage(onTap: provider.goBackToSelectCity, path: 'assets/svg/arrow_backward.svg', imageType: ImageType.svg, height: 40, width: 30, margin: EdgeInsets.only(right: 20)),
                Expanded(child: Center(child: Text(LocaleKeys.please_select_one_option_to_continue_your_ziarat.tr(), textAlign: TextAlign.center, style: CTextStyle.w500(fontSize: 24)))),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BasicCard(
                  onTap: () => ref.read(ziaratProvider.notifier).updateSelectedDestinationsCreationOption(ZiaratDestinationsCreationOptions.auto),
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  borderColor: isAutoSelected ? null : CColors.greyShade2,
                  boxShadow: isAutoSelected ? null : [],
                  borderWidth: 3,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(LocaleKeys.auto_generate.tr(), style: CTextStyle.w400(fontSize: 24, color: isAutoSelected ? CColors.primary : CColors.greyShade2)),
                        ),
                        Text(LocaleKeys.auto_generate_description.tr(), style: CTextStyle.w400(fontSize: 14, color: isAutoSelected ? CColors.primary : CColors.greyShade2)),
                      ],
                    ),
                  ),
                ),
                BasicCard(
                  onTap: () => ref.read(ziaratProvider.notifier).updateSelectedDestinationsCreationOption(ZiaratDestinationsCreationOptions.manual),
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: const EdgeInsets.only(top: 30, bottom: 30),
                  borderColor: isManualSelected ? CColors.primary : CColors.greyShade2,
                  boxShadow: isManualSelected ? null : [],
                  borderWidth: 3,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(LocaleKeys.manual_selection.tr(), style: CTextStyle.w400(fontSize: 24, color: isManualSelected ? CColors.primary : CColors.greyShade2)),
                        ),
                        Text(LocaleKeys.manual_selection_description.tr(), style: CTextStyle.w400(fontSize: 14, color: isManualSelected ? CColors.primary : CColors.greyShade2)),
                      ],
                    ),
                  ),
                ),
                if (ref.watch(ziaratProvider).selectedDestinationsCreationOption != null)
                  CButton(margin: const EdgeInsets.only(bottom: 30), isLoading: provider.isLoading, onTap: () => provider.generateZiarat(context), title: LocaleKeys.proceed_forward.tr(), width: 200),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
