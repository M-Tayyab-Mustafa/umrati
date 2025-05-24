import '../../../export.dart';

final mapPageProvider = ChangeNotifierProvider.autoDispose<MapPageNotifier>((ref) => MapPageNotifier());

class MapPageNotifier extends ChangeNotifier {
  GoogleMapController? _controller;
  StreamSubscription<Position>? _positionStream;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  UserModel? user;

  //* Destinations
  List<ZiaratModel> destinations = [];

  set mapController(GoogleMapController? controller) {
    _controller = controller;
    notifyListeners();
  }

  CameraPosition initialCameraPosition = CameraPosition(target: LatLng(30.17271735209673, 71.45729802421867), zoom: 20);

  initialization(BuildContext context) async {
    var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
    initialCameraPosition = CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude), zoom: 20);
    markers.add(Marker(markerId: MarkerId(MapMarkerId.userLocation.name), position: initialCameraPosition.target, icon: await _loadCustomIcon('assets/png/map/user.png')));
    _controller?.animateCamera(CameraUpdate.newLatLng(initialCameraPosition.target));
    //* Fetch Destinations
    user = await LocalStorageManager.getUser();
    var data = (await userCollection.doc(user!.uid).get()).data()!;
    destinations = List.from(data[CommonField.selectedZiarat.name]).map((e) => ZiaratModel.fromMap(e)).toList(growable: false);
    //* First Destination Marker
    markers.add(
      Marker(
        markerId: MarkerId(MapMarkerId.destination.name),
        position: LatLng(destinations.first.lat.toDouble(), destinations.first.lng.toDouble()),
        icon: await _loadCustomIcon('assets/png/map/destination.png'),
      ),
    );
    notifyListeners();
    await _getRoutePolyline(initialCameraPosition.target, LatLng(destinations.first.lat.toDouble(), destinations.first.lng.toDouble()));
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 5)).listen(_updateLocation);
  }

  _updateLocation(Position position) async {
    markers =
        markers.where((e) => e.markerId.value != MapMarkerId.userLocation.name).toSet()
          ..add(Marker(markerId: MarkerId(MapMarkerId.userLocation.name), position: LatLng(position.latitude, position.longitude), icon: await _loadCustomIcon('assets/png/map/user.png')));
    var distance = Geolocator.distanceBetween(position.latitude, position.longitude, destinations.first.lat.toDouble(), destinations.first.lng.toDouble());

    if (distance < 20) {
      destinations.removeAt(0);
      await userCollection.doc(user!.uid).set({CommonField.selectedZiarat.name: destinations.map((e) => e.toMap()).toList()}, SetOptions(merge: true));
      if (destinations.isEmpty) {
        _positionStream?.cancel();
        return;
      }
      markers =
          markers.where((e) => e.markerId.value != MapMarkerId.destination.name).toSet()
            ..add(Marker(markerId: MarkerId(MapMarkerId.destination.name), position: LatLng(position.latitude, position.longitude), icon: await _loadCustomIcon('assets/png/map/destination.png')));
    }
    await _getRoutePolyline(LatLng(position.latitude, position.longitude), LatLng(destinations.first.lat.toDouble(), destinations.first.lng.toDouble()));

    notifyListeners();
  }

  Future<AssetMapBitmap> _loadCustomIcon(String icon) async {
    return await BitmapDescriptor.asset(ImageConfiguration(size: Size(25, 25)), icon);
  }

  Future<void> _getRoutePolyline(LatLng startPoint, LatLng endPoint) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&mode=driving&key=$mapsApiKey';

    final response = await get(Uri.parse(url));
    log(response.body);
    var body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['routes'].isNotEmpty) {
      final points = body['routes'][0]['overview_polyline']['points'];
      final List<LatLng> routeCoords = _decodePolyline(points);
      polylines.add(Polyline(polylineId: PolylineId("route"), points: routeCoords, color: CColors.primary, width: 5));
    } else {
      polylines.add(Polyline(polylineId: PolylineId("route"), points: [startPoint, endPoint], color: CColors.primary, width: 5));
    }
    notifyListeners();
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _positionStream?.cancel();
    super.dispose();
  }
}
