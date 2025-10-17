import '../../../../export.dart';

class ZiaraatDetailPage extends ConsumerStatefulWidget {
  const ZiaraatDetailPage({super.key, required this.ziaraatHistory});
  final ZiaraatHistoryModel ziaraatHistory;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZiaraatDetailPageState();
}

class _ZiaraatDetailPageState extends ConsumerState<ZiaraatDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.read(ziaraatDetailProvider.notifier).context = context;
    ref.read(ziaraatDetailProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(ziaraatDetailProvider.notifier).initialization(widget.ziaraatHistory);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(ziaraatDetailProvider);
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      margin: SizeConfig.only(top: kToolbarHeight * 0.5, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: SizeConfig.only(top: 16), child: Text('${LocaleKeys.your_current_location.tr()}:', style: CTextStyle.w500(fontSize: 22))),
          Text(provider.myCurrentLocation, style: CTextStyle.w500(fontSize: 14, color: CColors.deepTeal)),
          Padding(padding: SizeConfig.only(top: 16), child: Text(LocaleKeys.your_ziaraat_destinations.tr(), style: CTextStyle.w500(fontSize: 20))),
          Expanded(
            child:
                provider.isLoading
                    ? Loading()
                    : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: SizeConfig.zero,
                            itemCount: provider.ziaraatHistory!.completedZiaraats.length,
                            itemBuilder: (context, index) {
                              var ziaraat = provider.ziaraatHistory!.completedZiaraats[index];
                              return CMarker(color: CColors.secondary, indicatorColor: CColors.secondary, title: isLTR(context) ? ziaraat.title_en : ziaraat.title_ur, distance: ziaraat.distance);
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: SizeConfig.zero,
                            itemCount: provider.ziaraatHistory!.remainingZiaraats.length,
                            itemBuilder: (context, index) {
                              var ziaraat = provider.ziaraatHistory!.remainingZiaraats[index];
                              return CMarker(title: isLTR(context) ? ziaraat.title_en : ziaraat.title_ur, distance: ziaraat.distance);
                            },
                          ),
                        ],
                      ),
                    ),
          ),
          if (!provider.isLoading)
            Padding(
              padding: SizeConfig.only(bottom: 32),
              child: Row(
                children: [
                  CButton(
                    onTap: () => Navigator.pop(context),
                    title: LocaleKeys.go_back.tr(),
                    useTitleWidth: true,
                    backgroundColor: CColors.secondaryBackground,
                    borderColor: CColors.primary,
                    titleColor: CColors.primary,
                  ),
                  Spacer(),
                  if (!provider.ziaraatHistory!.isCompleted) CButton(onTap: provider.resume, title: LocaleKeys.resume_ziaraat.tr()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
