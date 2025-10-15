import '../../../../export.dart';
part 'auto_generated_ziarat_plan.dart';
part 'destinations.dart';
part 'manual_selection.dart';

class ZiaratPage extends ConsumerStatefulWidget {
  const ZiaratPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CitiesPageState();
}

class _CitiesPageState extends ConsumerState<ZiaratPage> {
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
      title: LocaleKeys.select_ziarat_cities.tr(),
      titleType: TitleType.backArrow,
      titleMargin: SizeConfig.symmetric(vertical: kToolbarHeight * 0.5),
      margin: SizeConfig.only(top: kToolbarHeight * 0.5, left: 16, right: 16),
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: SizeConfig.w(30),
            crossAxisSpacing: SizeConfig.w(30),
            children: [
              ZiaratCityCard(
                icon: 'assets/svg/ziarat/mecca.svg',
                title: LocaleKeys.Mecca.tr(),
                isSelected: provider.selectedCity == ZiaraatCities.mecca,
                onTap: () => provider.updateSelectedCity(ZiaraatCities.mecca),
              ),
              ZiaratCityCard(
                icon: 'assets/svg/ziarat/medina.svg',
                title: LocaleKeys.medina.tr(),
                isSelected: provider.selectedCity == ZiaraatCities.medina,
                onTap: () => provider.updateSelectedCity(ZiaraatCities.medina),
              ),
              ZiaratCityCard(
                icon: 'assets/svg/ziarat/taif.svg',
                title: LocaleKeys.taif.tr(),
                isSelected: provider.selectedCity == ZiaraatCities.taif,
                onTap: () => provider.updateSelectedCity(ZiaraatCities.taif),
              ),
              ZiaratCityCard(
                icon: 'assets/svg/ziarat/other.svg',
                title: LocaleKeys.others.tr(),
                isSelected: provider.selectedCity == ZiaraatCities.other,
                onTap: () => provider.updateSelectedCity(ZiaraatCities.other),
              ),
            ],
          ),
          if (provider.selectedCity != null)
            CButton(onTap: provider.goToDestinationGenerationPage, margin: SizeConfig.only(top: SizeConfig.screenHeight * 0.05), title: LocaleKeys.proceed_forward.tr()),
        ],
      ),
    );
  }
}
