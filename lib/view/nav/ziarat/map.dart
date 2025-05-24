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
    ref.read(mapPageProvider).initialization(context);
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
