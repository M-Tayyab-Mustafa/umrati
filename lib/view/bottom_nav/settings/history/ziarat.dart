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
      margin: EdgeInsets.only(top: kToolbarHeight / 2, left: 16, right: 16, bottom: kToolbarHeight / 2),
      backgroundType: BackgroundType.titleWithBackButton,
      logoAlign: Alignment.center,
      title: LocaleKeys.ziarat.tr(),
      child:
          provider.isLoading
              ? Loading()
              : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomImage(
                                margin: EdgeInsets.only(right: 8),
                                size: 30,
                                imageType: ImageType.svg,
                                color: CColors.primary,
                                path: switch (_getZiaratCity(history.ziaratCity)) {
                                  ZiaratCities.medina => 'assets/svg/ziarat/medina.svg',
                                  ZiaratCities.taif => 'assets/svg/ziarat/taif.svg',
                                  ZiaratCities.other => 'assets/svg/ziarat/other.svg',
                                  _ => 'assets/svg/ziarat/medina.svg',
                                },
                              ),
                              Text(Helper.generateTitle(history.ziaratCity), style: CTextStyle.w500(fontSize: 16, color: CColors.primary), textAlign: TextAlign.center),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: '${history.completedZiarats.length}', style: CTextStyle.w600(fontSize: 85, color: CColors.deepTeal)),
                                    TextSpan(text: '/${history.total}', style: CTextStyle.w600(fontSize: 30, color: CColors.deepTeal.withValues(alpha: 0.5))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CButton(
                            onTap: () => provider.onViewZiaratTap(history),
                            title: LocaleKeys.view.tr(),
                            borderRadius: BorderRadius.circular(40),
                            shadows: [],
                            height: 35,
                            width: 80,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
    );
  }

  ZiaratCities _getZiaratCity(String city) {
    if (city == ZiaratCities.medina.name) {
      return ZiaratCities.medina;
    } else if (city == ZiaratCities.taif.name) {
      return ZiaratCities.taif;
    } else if (city == ZiaratCities.other.name) {
      return ZiaratCities.other;
    } else {
      return ZiaratCities.mecca;
    }
  }
}
