part of 'page.dart';

class ManualSelection extends ConsumerWidget {
  const ManualSelection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(ziaratProvider);
    return Background(
      showEmblem: false,
      margin: EdgeInsets.only(top: kToolbarHeight, left: 16, right: 16),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                CustomImage(onTap: () => Navigator.pop(context), path: 'assets/svg/arrow_backward.svg', imageType: ImageType.svg, height: 40, width: 30, margin: EdgeInsets.only(right: 20)),
                Expanded(
                  child: Center(child: Text('${_cityName(provider.selectedCity!)} ${LocaleKeys.top_ziarat_destination_of.tr()}', textAlign: TextAlign.center, style: CTextStyle.w500(fontSize: 24))),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.ziarats.length,
              itemBuilder: (context, index) {
                var ziarat = provider.ziarats[index];
                return BasicCard(
                  margin: EdgeInsets.only(bottom: 16),
                  onTap: () => provider.updateSelectedZiarat(ziarat),
                  borderColor: provider.selectedZiarat.contains(ziarat) ? null : CColors.greyShade3,
                  boxShadow: provider.selectedZiarat.contains(ziarat) ? null : [],
                  child: Directionality(textDirection: getDirection(ziarat.title), child: Text(ziarat.title, style: CTextStyle.w500(fontSize: 16))),
                );
              },
            ),
          ),
          if (provider.selectedZiarat.isNotEmpty)
            CButton(isLoading: provider.isLoading, onTap: () => provider.createZiaratRoute(context), margin: EdgeInsets.only(bottom: 48), title: LocaleKeys.start_your_ziarat.tr(), width: 200),
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
