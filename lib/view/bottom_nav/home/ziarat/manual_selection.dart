part of 'page.dart';

class ManualSelection extends ConsumerWidget {
  const ManualSelection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaratProvider);
    return Background(
      showEmblem: false,
      title: '${_cityName(provider.selectedCity!)} ${LocaleKeys.top_ziarat_destination_of.tr()}',
      titleType: TitleType.backArrow,
      titleMargin: SizeConfig.symmetric(vertical: kToolbarHeight * 0.5),
      margin: SizeConfig.only(left: 16, right: 16),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: SizeConfig.zero,
              itemCount: provider.ziarats.length,
              itemBuilder: (context, index) {
                var ziarat = provider.ziarats[index];
                return BasicCard(
                  margin: SizeConfig.only(bottom: 20),
                  onTap: () => provider.updateSelectedZiarat(ziarat),
                  borderColor: provider.selectedZiarat.contains(ziarat) ? null : CColors.greyShade3,
                  boxShadow: provider.selectedZiarat.contains(ziarat) ? null : [],
                  child: Directionality(
                    textDirection: getTextDirection(isLTR(context) ? ziarat.title_en : ziarat.title_ur),
                    child: Text(isLTR(context) ? ziarat.title_en : ziarat.title_ur, style: CTextStyle.w500(fontSize: 14)),
                  ),
                );
              },
            ),
          ),
          if (provider.selectedZiarat.isNotEmpty)
            CButton(
              isLoading: provider.isLoading,
              onTap: provider.createZiaratRoute,
              margin: SizeConfig.only(bottom: SizeConfig.screenHeight * 0.05),
              title: LocaleKeys.start_your_ziarat.tr(),
              width: SizeConfig.w(150),
            ),
        ],
      ),
    );
  }

  String _cityName(ZiaratCities city) {
    switch (city) {
      case ZiaratCities.mecca:
        return LocaleKeys.Mecca.tr();
      case ZiaratCities.medina:
        return LocaleKeys.medina.tr();
      case ZiaratCities.taif:
        return LocaleKeys.taif.tr();
      default:
        return LocaleKeys.others.tr();
    }
  }
}
