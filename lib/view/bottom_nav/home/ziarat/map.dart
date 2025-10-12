import '../../../../export.dart';

class ZiaraatMapPage extends ConsumerStatefulWidget {
  const ZiaraatMapPage({super.key, this.ziaratHistory});
  final ZiaraatHistoryModel? ziaratHistory;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZiaratMapPageState();
}

class _ZiaratMapPageState extends ConsumerState<ZiaraatMapPage> {
  @override
  void initState() {
    super.initState();
    ref.read(mapPageProvider.notifier).context = context;
    ref.read(mapPageProvider.notifier).ref = ref;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(mapPageProvider.notifier).initialization(ziaratHistory: widget.ziaratHistory);
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
                  child: CustomImage(margin: SizeConfig.all(10), path: 'assets/svg/go_backward.svg', color: Colors.white, imageType: ImageType.svg, size: SizeConfig.w(20)),
                ),
              ),
            ),
            if (provider.activeZiarat != null)
              Align(
                alignment: Alignment(0.9, -0.9),
                child: GestureDetector(
                  onTap: () => provider.showMoreOptions(context: context),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: CustomImage(path: isLTR(context) ? 'assets/svg/ziarat/more_options.svg' : 'assets/svg/ziarat/more_options_ur.svg', imageType: ImageType.svg, size: SizeConfig.w(40)),
                  ),
                ),
              ),
            Align(alignment: Alignment(0.42, -0.92), child: CompositedTransformTarget(link: provider.layerLink, child: SizedBox(height: SizeConfig.w(20), width: SizeConfig.w(20)))),
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
      controlHeight: SizeConfig.h(SizeConfig.screenHeight * 0.13),
      panelController: provider.panelController,
      onTap: provider.hideMoreOptions,
      child: Container(
        decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(SizeConfig.r(30))))),
        child: SafeArea(
          child: Padding(
            padding: SizeConfig.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  getTextDirection(isLTR(context) ? provider.activeZiarat?.title_en ?? '' : provider.activeZiarat?.title_ur ?? '') == TextDirection.rtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Center(child: CustomImage(path: 'assets/svg/arrow_up.svg', imageType: ImageType.svg, width: SizeConfig.w(20))),
                _ZiaratDetailCard(
                  title: isLTR(context) ? provider.activeZiarat?.title_en ?? '' : provider.activeZiarat?.title_ur ?? '',
                  time: provider.activeZiarat?.time ?? '0 m',
                  distance: '${provider.activeZiarat?.distance.split(' ').first ?? 0}',
                ),
                if (provider.destinations.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: SizeConfig.zero,
                      itemCount: provider.destinations.sublist(1).length,
                      itemBuilder: (context, index) {
                        var ziarat = provider.destinations.sublist(1)[index];
                        return _ZiaratDetailCard(title: isLTR(context) ? ziarat.title_en : ziarat.title_ur, time: '', distance: ziarat.distance.split(' ').first, index: index + 1);
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

class _ZiaratDetailCard extends ConsumerWidget {
  const _ZiaratDetailCard({required this.title, required this.time, required this.distance, this.index = 0});
  final String title;
  final String time;
  final String distance;
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: getTextDirection(title),
      child: Padding(
        padding: SizeConfig.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: SizeConfig.only(top: 15),
              child: Text('${LocaleKeys.your.tr()} ${index + 1} ${LocaleKeys.ziarat.tr()}', style: CTextStyle.w500(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Padding(padding: SizeConfig.symmetric(vertical: 4), child: Text(title, style: CTextStyle.w500(), maxLines: 2, overflow: TextOverflow.ellipsis)),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(margin: SizeConfig.only(right: 5), path: 'assets/png/map/destination.png', imageType: ImageType.png, width: SizeConfig.w(11), fit: BoxFit.fitWidth),
                  Text('$distance Km', style: CTextStyle.w400(fontSize: 12, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (time.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImage(margin: SizeConfig.only(left: 80, right: 5), path: 'assets/svg/clock.svg', imageType: ImageType.svg, width: SizeConfig.w(18), fit: BoxFit.fitWidth),
                        Text(time, style: CTextStyle.w400(fontSize: 12, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                ],
              ),
            ),
            Padding(padding: SizeConfig.only(top: 16), child: Divider(color: CColors.charcoalBlack, thickness: 1, radius: BorderRadius.circular(SizeConfig.r(16)))),
          ],
        ),
      ),
    );
  }
}
