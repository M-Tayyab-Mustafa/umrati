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
      margin: EdgeInsets.only(top: kToolbarHeight / 2, left: 16, right: 16),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              itemCount: provider.ziarats.length,
              itemBuilder: (context, index) {
                var ziarat = provider.ziarats[index];
                return BasicCard(
                  margin: EdgeInsets.only(bottom: 16),
                  onTap: () => provider.updateSelectedZiarat(ziarat),
                  borderColor: provider.selectedZiarat.contains(ziarat) ? null : CColors.greyShade3,
                  boxShadow: provider.selectedZiarat.contains(ziarat) ? null : [],
                  child: Directionality(
                    textDirection: getTextDirection(languageDirection(context) == TextDirection.ltr ? ziarat.title_en : ziarat.title_ur),
                    child: Text(languageDirection(context) == TextDirection.ltr ? ziarat.title_en : ziarat.title_ur, style: CTextStyle.w500(fontSize: 16)),
                  ),
                );
              },
            ),
          ),
          if (provider.selectedZiarat.isNotEmpty)
            CButton(isLoading: provider.isLoading, onTap: provider.createZiaratRoute, margin: EdgeInsets.only(bottom: 48), title: LocaleKeys.start_your_ziarat.tr(), width: 200),
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
