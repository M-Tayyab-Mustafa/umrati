import '../../../../export.dart';

class ZiaraatHistoryPage extends ConsumerStatefulWidget {
  const ZiaraatHistoryPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZiaraatHistoryPageState();
}

class _ZiaraatHistoryPageState extends ConsumerState<ZiaraatHistoryPage> {
  @override
  void initState() {
    super.initState();
    ref.read(historyProvider.notifier).context = context;
    ref.read(historyProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).initialization(historyType: HistoryType.ziaraat);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(historyProvider);
    return Background(
      margin: EdgeInsets.zero,
      backgroundType: BackgroundType.titleWithBackButton,
      logoAlign: Alignment.center,
      title: LocaleKeys.ziaraat.tr(),
      child:
          provider.isLoading
              ? Loading()
              : provider.ziaraatHistories.isEmpty
              ? Center(child: Text(LocaleKeys.no_history_found.tr(), style: CTextStyle.w500(fontSize: 22), textAlign: TextAlign.center))
              : GridView.builder(
                shrinkWrap: true,
                padding: context.edgeInsets(vertical: 20, horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: context.h(20), crossAxisSpacing: context.w(20), childAspectRatio: 0.91),
                itemCount: provider.ziaraatHistories.length,
                itemBuilder: (context, index) {
                  var history = provider.ziaraatHistories[index];
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
                              margin: context.edgeInsets(right: 8),
                              size: context.h(20),
                              imageType: ImageType.svg,
                              color: CColors.primary,
                              path: switch (_getZiaraatCity(history.ziaraatCity)) {
                                ZiaraatCities.medina => 'assets/svg/ziaraat/medina.svg',
                                ZiaraatCities.taif => 'assets/svg/ziaraat/taif.svg',
                                ZiaraatCities.other => 'assets/svg/ziaraat/other.svg',
                                _ => 'assets/svg/ziaraat/medina.svg',
                              },
                            ),
                            Text(isLTR(context) ? Helper.generateTitle(history.ziaraatCity) : generateTitle(history.ziaraatCity), style: CTextStyle.w500(color: CColors.primary, fontSize: 14)),
                          ],
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(children: [TextSpan(text: '${history.completedZiaraats.length}'), TextSpan(text: '/${history.total}', style: CTextStyle.w600(fontSize: 30, color: CColors.deepTeal.withValues(alpha: 0.5)))]),
                            style: CTextStyle.w600(fontSize: 70, color: CColors.deepTeal, height: 1),
                          ),
                        ),
                        CButton(padding: EdgeInsets.zero, margin: context.edgeInsets(top: 4), onTap: () => provider.onViewZiaraatTap(history), title: LocaleKeys.view.tr(), borderRadius: BorderRadius.circular(40), height: 30, useTitleWidth: true),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  ZiaraatCities _getZiaraatCity(String city) {
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
