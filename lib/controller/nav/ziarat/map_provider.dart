import '../../../export.dart';

final mapPageProvider = ChangeNotifierProvider.autoDispose<MapPageNotifier>((ref) => MapPageNotifier());

class MapPageNotifier extends ChangeNotifier {
  GoogleMapController? _googleMapController;

  get initialCameraPosition => CameraPosition(target: LatLng(35.915526, 64.811111));
  set mapController(GoogleMapController? value) {
    _googleMapController = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }
}
