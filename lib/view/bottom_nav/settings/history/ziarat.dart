import '../../../../export.dart';

class ZiaratHistoryPage extends ConsumerStatefulWidget {
  const ZiaratHistoryPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZiaratHistoryPageState();
}

class _ZiaratHistoryPageState extends ConsumerState<ZiaratHistoryPage> {
  @override
  void initState() {
    super.initState();
    ref.read(historyProvider.notifier).context = context;
    ref.read(historyProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).initialization(historyType: HistoryType.ziarat);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(historyProvider);
    return Background(
      margin: SizeConfig.zero,
      backgroundType: BackgroundType.titleWithBackButton,
      logoAlign: Alignment.center,
      title: LocaleKeys.ziarat.tr(),
      child:
          provider.isLoading
              ? Loading()
              : provider.ziaratHistories.isEmpty
              ? Center(child: Text(LocaleKeys.no_history_found.tr(), style: CTextStyle.w500(fontSize: 22), textAlign: TextAlign.center))
              : GridView.builder(
                shrinkWrap: true,
                padding: SizeConfig.symmetric(vertical: 20, horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: SizeConfig.w(30), crossAxisSpacing: SizeConfig.w(30)),
                itemCount: provider.ziaratHistories.length,
                itemBuilder: (context, index) {
                  var history = provider.ziaratHistories[index];
                  return BasicCard(
                    boxShadow: [],
                    borderColor: CColors.charcoalBlack,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomImage(
                              margin: SizeConfig.only(right: 8),
                              size: SizeConfig.w(25),
                              imageType: ImageType.svg,
                              color: CColors.primary,
                              path: switch (_getZiaratCity(history.ziaratCity)) {
                                ZiaraatCities.medina => 'assets/svg/ziarat/medina.svg',
                                ZiaraatCities.taif => 'assets/svg/ziarat/taif.svg',
                                ZiaraatCities.other => 'assets/svg/ziarat/other.svg',
                                _ => 'assets/svg/ziarat/medina.svg',
                              },
                            ),
                            Text(isLTR(context) ? Helper.generateTitle(history.ziaratCity) : generateTitle(history.ziaratCity), style: CTextStyle.w500(color: CColors.primary, fontSize: 14)),
                          ],
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: '${history.completedZiarats.length}'),
                                TextSpan(text: '/${history.total}', style: CTextStyle.w600(fontSize: 30, color: CColors.deepTeal.withValues(alpha: 0.5))),
                              ],
                            ),
                            style: CTextStyle.w600(fontSize: 70, color: CColors.deepTeal, height: 1),
                          ),
                        ),
                        CButton(
                          padding: SizeConfig.zero,
                          margin: SizeConfig.only(top: 4),
                          onTap: () => provider.onViewZiaratTap(history),
                          title: LocaleKeys.view.tr(),
                          borderRadius: BorderRadius.circular(40),
                          height: 30,
                          useTitleWidth: true,
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  ZiaraatCities _getZiaratCity(String city) {
    if (city == ZiaraatCities.medina.name) {
      return ZiaraatCities.medina;
    } else if (city == ZiaraatCities.taif.name) {
      return ZiaraatCities.taif;
    } else if (city == ZiaraatCities.other.name) {
      return ZiaraatCities.other;
    } else {
      return ZiaraatCities.mecca;
    }
  }

  String generateTitle(String city) {
    if (city == ZiaraatCities.medina.name) {
      return LocaleKeys.medina.tr();
    } else if (city == ZiaraatCities.taif.name) {
      return LocaleKeys.taif.tr();
    } else if (city == ZiaraatCities.other.name) {
      return LocaleKeys.others.tr();
    } else {
      return LocaleKeys.Mecca.tr();
    }
  }
}
