part of 'page.dart';

class ManualSelection extends ConsumerWidget {
  const ManualSelection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaraatProvider);
    return Background(
      showEmblem: false,
      title: '${LocaleKeys.top_ziaraat_destination_of.tr()} ${_cityName(provider.selectedCity!)}',
      titleType: TitleType.backArrow,
      titleMargin: context.edgeInsets(vertical: kToolbarHeight * 0.5),
      margin: context.edgeInsets(left: 16, right: 16),
      child: Column(
        children: [
          Expanded(
            child:
                provider.ziaraats.isEmpty
                    ? Center(child: Text(LocaleKeys.ziaraat_not_found.tr(), style: CTextStyle.w500(fontSize: 22), textAlign: TextAlign.center))
                    : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: provider.ziaraats.length,
                            itemBuilder: (context, index) {
                              var ziaraat = provider.ziaraats[index];
                              return BasicCard(
                                margin: context.edgeInsets(bottom: 20),
                                onTap: () => provider.updateSelectedZiaraat(ziaraat),
                                borderColor: provider.selectedZiaraat.contains(ziaraat) ? null : CColors.greyShade3,
                                boxShadow: provider.selectedZiaraat.contains(ziaraat) ? null : [],
                                child: Directionality(textDirection: getTextDirection(isLTR(context) ? ziaraat.title_en : ziaraat.title_ur), child: Text(isLTR(context) ? ziaraat.title_en : ziaraat.title_ur, style: CTextStyle.w500(fontSize: 14))),
                              );
                            },
                          ),
                          if ((!(provider.user?.is_premium ?? false)) && !Platform.isIOS) CButton(isLoading: provider.isLoading, onTap: provider.onLoadMoreTap, margin: context.edgeInsets(top: 32), title: LocaleKeys.load_more.tr()),
                        ],
                      ),
                    ),
          ),
          if (provider.selectedZiaraat.isNotEmpty) CButton(margin: context.edgeInsets(top: 16, bottom: 64), isLoading: provider.isLoading, onTap: provider.createZiaraatRoute, title: LocaleKeys.start_your_ziaraat.tr()),
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
