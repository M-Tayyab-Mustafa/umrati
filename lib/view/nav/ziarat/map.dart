import '../../../controller/nav/ziarat/map_provider.dart';
import '../../../export.dart';

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
      bottomSheet: _BottomSheet(),
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
          ),
          Align(
            alignment: Alignment(-0.9, -0.9),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                height: 40,
                width: 40,
                child: CustomImage(path: 'assets/svg/go_backward.svg', color: Colors.white, imageType: ImageType.svg, width: 25, height: 25, borderRadius: BorderRadius.circular(999)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(mapPageProvider);
    return SizedBox(
      height: provider.bottomSheetSize,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImage(path: 'assets/svg/arrow_up.svg', imageType: ImageType.svg, height: 30, width: 30),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 15), child: Text(provider.activeZiarat?.title ?? '', style: CTextStyle.w500(fontSize: 18), maxLines: 2, overflow: TextOverflow.ellipsis)),
                  Row(
                    children: [
                      CustomImage(margin: EdgeInsets.only(right: 5), path: 'assets/png/map/destination.png', imageType: ImageType.png, height: 15, width: 15),
                      Text('${provider.activeZiarat?.distance ?? 0} Km', style: CTextStyle.w400(fontSize: 14, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      CustomImage(margin: EdgeInsets.only(left: 80), path: 'assets/svg/clock.svg', imageType: ImageType.svg, height: 20, width: 20),
                      Text(provider.activeZiarat?.time ?? '0 m', style: CTextStyle.w400(fontSize: 14, color: CColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
