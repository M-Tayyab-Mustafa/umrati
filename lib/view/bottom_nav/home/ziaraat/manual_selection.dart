part of 'page.dart';

class ManualSelection extends ConsumerWidget {
  const ManualSelection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaraatProvider);
    return Background(
      showEmblem: false,
      title: '${_cityName(provider.selectedCity!)} ${LocaleKeys.top_ziaraat_destination_of.tr()}',
      titleType: TitleType.backArrow,
      titleMargin: SizeConfig.symmetric(vertical: kToolbarHeight * 0.5),
      margin: SizeConfig.only(left: 16, right: 16),
      child: Column(
        children: [
          Expanded(
            child:
                provider.ziaraats.isEmpty
                    ? Center(child: Text(LocaleKeys.ziaraat_not_found.tr(), style: CTextStyle.w500(fontSize: 22), textAlign: TextAlign.center))
                    : ListView.builder(
                      padding: SizeConfig.zero,
                      itemCount: provider.ziaraats.length,
                      itemBuilder: (context, index) {
                        var ziaraat = provider.ziaraats[index];
                        return BasicCard(
                          margin: SizeConfig.only(bottom: 20),
                          onTap: () => provider.updateSelectedZiaraat(ziaraat),
                          borderColor: provider.selectedZiaraat.contains(ziaraat) ? null : CColors.greyShade3,
                          boxShadow: provider.selectedZiaraat.contains(ziaraat) ? null : [],
                          child: Directionality(
                            textDirection: getTextDirection(isLTR(context) ? ziaraat.title_en : ziaraat.title_ur),
                            child: Text(isLTR(context) ? ziaraat.title_en : ziaraat.title_ur, style: CTextStyle.w500(fontSize: 14)),
                          ),
                        );
                      },
                    ),
          ),
          if (provider.selectedZiaraat.isNotEmpty)
            CButton(isLoading: provider.isLoading, onTap: provider.createZiaraatRoute, margin: SizeConfig.only(bottom: SizeConfig.screenHeight * 0.05), title: LocaleKeys.start_your_ziaraat.tr()),
        ],
      ),
    );
  }

  String _cityName(ZiaraatCities city) {
    switch (city) {
      case ZiaraatCities.mecca:
        return LocaleKeys.Mecca.tr();
      case ZiaraatCities.medina:
        return LocaleKeys.medina.tr();
      case ZiaraatCities.taif:
        return LocaleKeys.taif.tr();
      default:
        return LocaleKeys.others.tr();
    }
  }
}
