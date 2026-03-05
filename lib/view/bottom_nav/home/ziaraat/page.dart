import '../../../../export.dart';
part 'auto_generated_ziaraat_plan.dart';
part 'destinations.dart';
part 'manual_selection.dart';

class ZiaraatPage extends ConsumerStatefulWidget {
  const ZiaraatPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CitiesPageState();
}

class _CitiesPageState extends ConsumerState<ZiaraatPage> {
  @override
  void initState() {
    super.initState();
    ref.read(ziaraatProvider.notifier).initialization();
    ref.read(ziaraatProvider.notifier).ref = ref;
    ref.read(ziaraatProvider.notifier).context = context;
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(ziaraatProvider);
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      title: LocaleKeys.select_ziaraat_cities.tr(),
      titleType: TitleType.backArrow,
      titleMargin: context.edgeInsets(vertical: kToolbarHeight * 0.5),
      margin: context.edgeInsets(top: kToolbarHeight * 0.5, left: 16, right: 16),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: context.h(30),
            crossAxisSpacing: context.w(30),
            children: [
              ZiaraatCityCard(icon: 'assets/svg/ziaraat/mecca.svg', title: LocaleKeys.Mecca.tr(), isSelected: provider.selectedCity == ZiaraatCities.mecca, onTap: () => provider.updateSelectedCity(ZiaraatCities.mecca)),
              ZiaraatCityCard(icon: 'assets/svg/ziaraat/medina.svg', title: LocaleKeys.medina.tr(), isSelected: provider.selectedCity == ZiaraatCities.medina, onTap: () => provider.updateSelectedCity(ZiaraatCities.medina)),
              ZiaraatCityCard(icon: 'assets/svg/ziaraat/taif.svg', title: LocaleKeys.taif.tr(), isSelected: provider.selectedCity == ZiaraatCities.taif, onTap: () => provider.updateSelectedCity(ZiaraatCities.taif)),
              ZiaraatCityCard(icon: 'assets/svg/ziaraat/other.svg', title: LocaleKeys.others.tr(), isSelected: provider.selectedCity == ZiaraatCities.other, onTap: () => provider.updateSelectedCity(ZiaraatCities.other)),
            ],
          ),
          if (provider.selectedCity != null) CButton(onTap: provider.goToDestinationGenerationPage, margin: context.edgeInsets(top: 64), title: LocaleKeys.proceed_forward.tr()),
        ],
      ),
    );
  }
}
