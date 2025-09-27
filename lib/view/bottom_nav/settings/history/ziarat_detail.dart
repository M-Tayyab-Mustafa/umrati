import '../../../../export.dart';

class ZiaratDetailPage extends ConsumerStatefulWidget {
  const ZiaratDetailPage({super.key, required this.ziaratHistory});
  final ZiaratHistoryModel ziaratHistory;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZiaratDetailPageState();
}

class _ZiaratDetailPageState extends ConsumerState<ZiaratDetailPage> {
  @override
  void initState() {
    super.initState();
    ref.read(ziaratDetailProvider.notifier).context = context;
    ref.read(ziaratDetailProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(ziaratDetailProvider.notifier).initialization(widget.ziaratHistory);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(ziaratDetailProvider);
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.centerLeft,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06, bottom: 85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('${LocaleKeys.your_current_location.tr()}:', style: CTextStyle.w500(fontSize: 22)),
          ),
          Text(provider.myCurrentLocation, style: CTextStyle.w500(fontSize: 14, color: CColors.deepTeal)),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(LocaleKeys.your_ziarat_destinations.tr(), style: CTextStyle.w500(fontSize: 20)),
          ),
          Expanded(
            child: provider.isLoading
                ? Loading()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: provider.ziaratHistory!.completedZiarats.length,
                          itemBuilder: (context, index) {
                            var ziarat = provider.ziaratHistory!.completedZiarats[index];
                            return CMarker(color: CColors.emeraldGreen, title: languageDirection(context) == TextDirection.ltr ? ziarat.title_en : ziarat.title_ur, distance: ziarat.distance);
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: provider.ziaratHistory!.remainingZiarats.length,
                          itemBuilder: (context, index) {
                            var ziarat = provider.ziaratHistory!.remainingZiarats[index];
                            return CMarker(title: languageDirection(context) == TextDirection.ltr ? ziarat.title_en : ziarat.title_ur, distance: ziarat.distance);
                          },
                        ),
                      ],
                    ),
                  ),
          ),
          if (!provider.isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                children: [
                  CButton(
                    onTap: () => Navigator.pop(context),
                    title: LocaleKeys.go_back.tr(),
                    backgroundColor: Colors.transparent,
                    borderColor: CColors.primary,
                    titleColor: CColors.primary,
                    shadows: [],
                  ),
                  Spacer(),
                  if (!provider.ziaratHistory!.isCompleted) CButton(onTap: provider.resume, title: LocaleKeys.resume_ziarat.tr()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
