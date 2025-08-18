import '../../../../export.dart';

class ZiaratMapPage extends ConsumerStatefulWidget {
  const ZiaratMapPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ZiaratMapPageState();
}

class _ZiaratMapPageState extends ConsumerState<ZiaratMapPage> {
  @override
  void initState() {
    super.initState();
    ref.read(mapPageProvider).initialization(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(mapPageProvider);
    return Scaffold(
      body: Stack(
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
                height: 40,
                width: 40,
                child: CustomImage(path: 'assets/svg/go_backward.svg', color: Colors.white, imageType: ImageType.svg, width: 20, height: 20, borderRadius: BorderRadius.circular(999)),
              ),
            ),
          ),
          if (provider.activeZiarat != null)
            Align(
              alignment: Alignment(0.9, -0.9),
              child: GestureDetector(
                onTap: () => provider.showMoreOptions(context: context),
                child: CustomImage(path: 'assets/svg/ziarat/more_options.svg', imageType: ImageType.svg, width: 45, height: 45, borderRadius: BorderRadius.circular(999)),
              ),
            ),
          Align(alignment: Alignment(0.42, -0.92), child: CompositedTransformTarget(link: provider.layerLink, child: SizedBox(height: 20, width: 20))),
          _BottomSheet(),
        ],
      ),
    );
  }
}

class _BottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(mapPageProvider);
    return SlidingUpPanelWidget(
      controlHeight: provider.bottomSheetSize,
      panelController: provider.panelController,
      onTap: provider.hideMoreOptions,
      child: Container(
        decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30)))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: getDirection(provider.activeZiarat?.title ?? '') == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Center(child: CustomImage(path: 'assets/svg/arrow_up.svg', imageType: ImageType.svg, height: 30, width: 30)),
              ziaratDetailCard(title: provider.activeZiarat?.title ?? '', time: provider.activeZiarat?.time ?? '0 m', distance: '${provider.activeZiarat?.distance.split(' ').first ?? 0}'),
              if (provider.destinations.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.destinations.sublist(1).length,
                    itemBuilder: (context, index) {
                      var ziarat = provider.destinations.sublist(1)[index];
                      return ziaratDetailCard(title: ziarat.title, time: '', distance: ziarat.distance.split(' ').first, index: index + 1);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ziaratDetailCard({required String title, required String time, required String distance, int index = 0}) {
    return Directionality(
      textDirection: getDirection(title),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text('${LocaleKeys.your.tr()} ${index + 1} ${LocaleKeys.ziarat.tr()}', style: CTextStyle.w500(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Padding(padding: const EdgeInsets.only(top: 4), child: Text(title, style: CTextStyle.w500(fontSize: 18), maxLines: 2, overflow: TextOverflow.ellipsis)),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(margin: EdgeInsets.only(right: 5), path: 'assets/png/map/destination.png', imageType: ImageType.png, height: 15, width: 15),
                  Text('$distance Km', style: CTextStyle.w400(fontSize: 14, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (time.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImage(margin: EdgeInsets.only(left: 80), path: 'assets/svg/clock.svg', imageType: ImageType.svg, height: 20, width: 20),
                        Text(time, style: CTextStyle.w400(fontSize: 14, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 16), child: Divider(color: CColors.charcoalBlack, thickness: 1, radius: BorderRadius.circular(16))),
          ],
        ),
      ),
    );
  }
}
