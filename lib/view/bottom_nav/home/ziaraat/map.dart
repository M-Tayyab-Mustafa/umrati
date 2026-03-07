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
              onTap: (_) => provider.hideMoreOptions(),
            ),
            Align(
              alignment: const Alignment(-0.9, -0.9),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: const BoxDecoration(color: CColors.charcoalBlack, shape: BoxShape.circle),
                  child: CustomImage(margin: context.edgeInsets(all: 10), path: 'assets/svg/go_backward.svg', color: Colors.white, imageType: ImageType.svg, size: context.r(20)),
                ),
              ),
            ),
            if (provider.activeZiaraat != null)
              Align(
                alignment: const Alignment(0.9, -0.9),
                child: GestureDetector(
                  onTap: () => provider.showMoreOptions(context: context),
                  child: Directionality(textDirection: TextDirection.ltr, child: CustomImage(path: isLTR(context) ? 'assets/svg/ziaraat/more_options.svg' : 'assets/svg/ziaraat/more_options_ur.svg', imageType: ImageType.svg, size: context.r(40))),
                ),
              ),
            Align(alignment: const Alignment(0.42, -0.92), child: CompositedTransformTarget(link: provider.layerLink, child: SizedBox(height: context.r(20), width: context.r(20)))),
            const _MapBottomSheet(),
          ],
        ),
      ),
    );
  }
}

class _MapBottomSheet extends ConsumerWidget {
  const _MapBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(mapPageProvider);
    return SlidingUpPanelWidget(
      controlHeight: context.h(120),
      panelController: provider.panelController,
      onTap: provider.hideMoreOptions,
      child: Container(
        decoration: ShapeDecoration(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(30))))),
        child: SafeArea(
          child: Padding(
            padding: context.edgeInsets(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: getTextDirection(isLTR(context) ? provider.activeZiaraat?.title_en ?? '' : provider.activeZiaraat?.title_ur ?? '') == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Center(child: CustomImage(path: 'assets/svg/arrow_up.svg', imageType: ImageType.svg, width: context.w(20))),
                _ZiaraatDetailCard(
                  title: isLTR(context) ? provider.activeZiaraat?.title_en ?? '' : provider.activeZiaraat?.title_ur ?? '',
                  time: provider.activeZiaraat?.time ?? '0 m',
                  distance: '${provider.activeZiaraat?.distance.split(' ').first ?? 0}',
                ),
                if (provider.destinations.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: provider.destinations.sublist(1).length,
                      itemBuilder: (context, index) {
                        final ziaraat = provider.destinations.sublist(1)[index];
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

class _ZiaraatDetailCard extends StatelessWidget {
  const _ZiaraatDetailCard({required this.title, required this.time, required this.distance, this.index = 0});

  final String title;
  final String time;
  final String distance;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: getTextDirection(title),
      child: Padding(
        padding: context.edgeInsets(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: context.edgeInsets(top: 5), child: Text('${LocaleKeys.your.tr()} ${index + 1} ${LocaleKeys.ziaraat.tr()}', style: CTextStyle.w500(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
            Padding(padding: context.edgeInsets(vertical: 4), child: Text(title, style: CTextStyle.w500(), maxLines: 2, overflow: TextOverflow.ellipsis)),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImage(margin: context.edgeInsets(right: 5), path: 'assets/png/map/destination.png', imageType: ImageType.png, width: context.w(11), fit: BoxFit.fitWidth),
                  Text('$distance Km', style: CTextStyle.w400(fontSize: 12, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (time.isNotEmpty) ...[
                    CustomImage(margin: context.edgeInsets(left: 80, right: 5), path: 'assets/svg/clock.svg', imageType: ImageType.svg, width: context.w(18), fit: BoxFit.fitWidth),
                    Text(time, style: CTextStyle.w400(fontSize: 12, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            Padding(padding: context.edgeInsets(top: 16), child: Divider(color: CColors.charcoalBlack, thickness: 1, radius: BorderRadius.circular(context.r(16)))),
          ],
        ),
      ),
    );
  }
}
