import '../../../../export.dart';

class ZiaraatMapPage extends ConsumerStatefulWidget {
  const ZiaraatMapPage({super.key, this.ziaraatHistory});
  final ZiaraatHistoryModel? ziaraatHistory;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZiaraatMapPageState();
}

class _ZiaraatMapPageState extends ConsumerState<ZiaraatMapPage> {
  @override
  void initState() {
    super.initState();
    ref.read(mapPageProvider.notifier).context = context;
    ref.read(mapPageProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(mapPageProvider.notifier).initialization(ziaraatHistory: widget.ziaraatHistory);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(mapPageProvider);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: provider.initialCameraPosition,
              onMapCreated: (controller) => provider.mapController = controller,
              myLocationEnabled: false,
              markers: provider.markers,
              zoomControlsEnabled: false,
              polylines: provider.polylines,
              onTap: (argument) => provider.hideMoreOptions(),
            ),
            Align(
              alignment: Alignment(-0.9, -0.9),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(color: CColors.charcoalBlack, shape: BoxShape.circle),
                  child: CustomImage(margin: ScaledEdgeInsets.all(10), path: 'assets/svg/go_backward.svg', color: Colors.white, imageType: ImageType.svg, size: 20.pr),
                ),
              ),
            ),
            if (provider.activeZiaraat != null)
              Align(
                alignment: Alignment(0.9, -0.9),
                child: GestureDetector(
                  onTap: () => provider.showMoreOptions(context: context),
                  child: Directionality(textDirection: TextDirection.ltr, child: CustomImage(path: isLTR(context) ? 'assets/svg/ziaraat/more_options.svg' : 'assets/svg/ziaraat/more_options_ur.svg', imageType: ImageType.svg, size: 40.pr)),
                ),
              ),
            Align(alignment: Alignment(0.42, -0.92), child: CompositedTransformTarget(link: provider.layerLink, child: SizedBox(height: 20.pr, width: 20.pr))),
            _BottomSheet(),
          ],
        ),
      ),
    );
  }
}

class _BottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(mapPageProvider);
    return SlidingUpPanelWidget(
      controlHeight: 150.pr,
      panelController: provider.panelController,
      onTap: provider.hideMoreOptions,
      child: Container(
        decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.pr)))),
        child: SafeArea(
          child: Padding(
            padding: ScaledEdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: getTextDirection(isLTR(context) ? provider.activeZiaraat?.title_en ?? '' : provider.activeZiaraat?.title_ur ?? '') == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Center(child: CustomImage(path: 'assets/svg/arrow_up.svg', imageType: ImageType.svg, width: 20.pr)),
                _ZiaraatDetailCard(
                  title: isLTR(context) ? provider.activeZiaraat?.title_en ?? '' : provider.activeZiaraat?.title_ur ?? '',
                  time: provider.activeZiaraat?.time ?? '0 m',
                  distance: '${provider.activeZiaraat?.distance.split(' ').first ?? 0}',
                ),
                if (provider.destinations.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: ScaledEdgeInsets.zero,
                      itemCount: provider.destinations.sublist(1).length,
                      itemBuilder: (context, index) {
                        var ziaraat = provider.destinations.sublist(1)[index];
                        return _ZiaraatDetailCard(title: isLTR(context) ? ziaraat.title_en : ziaraat.title_ur, time: '', distance: ziaraat.distance.split(' ').first, index: index + 1);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ZiaraatDetailCard extends ConsumerWidget {
  const _ZiaraatDetailCard({required this.title, required this.time, required this.distance, this.index = 0});
  final String title;
  final String time;
  final String distance;
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: getTextDirection(title),
      child: Padding(
        padding: ScaledEdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: ScaledEdgeInsets.only(top: 15), child: Text('${LocaleKeys.your.tr()} ${index + 1} ${LocaleKeys.ziaraat.tr()}', style: CTextStyle.w500(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
            Padding(padding: ScaledEdgeInsets.symmetric(vertical: 4), child: Text(title, style: CTextStyle.w500(), maxLines: 2, overflow: TextOverflow.ellipsis)),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(margin: ScaledEdgeInsets.only(right: 5), path: 'assets/png/map/destination.png', imageType: ImageType.png, width: 11.pr, fit: BoxFit.fitWidth),
                  Text('$distance Km', style: CTextStyle.w400(fontSize: 12, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (time.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImage(margin: ScaledEdgeInsets.only(left: 80, right: 5), path: 'assets/svg/clock.svg', imageType: ImageType.svg, width: 18.pr, fit: BoxFit.fitWidth),
                        Text(time, style: CTextStyle.w400(fontSize: 12, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                ],
              ),
            ),
            Padding(padding: ScaledEdgeInsets.only(top: 16), child: Divider(color: CColors.charcoalBlack, thickness: 1, radius: BorderRadius.circular(16.pr))),
          ],
        ),
      ),
    );
  }
}
