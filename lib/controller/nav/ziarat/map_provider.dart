import '../../../export.dart';

final mapPageProvider = ChangeNotifierProvider.autoDispose<MapPageNotifier>((ref) => MapPageNotifier());

class MapPageNotifier extends ChangeNotifier {
  GoogleMapController? _controller;
  StreamSubscription<Position>? _positionStream;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  UserModel? user;

  var bottomSheetSize = screenSize.height * 0.15;

  ZiaratModel? activeZiarat;
  //* Destinations
  List<ZiaratModel> destinations = [];

  set mapController(GoogleMapController? controller) {
    _controller = controller;
    notifyListeners();
  }

  CameraPosition initialCameraPosition = CameraPosition(target: LatLng(30.17271735209673, 71.45729802421867), zoom: 20);

  initialization(BuildContext context, WidgetRef ref) async {
    var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
    initialCameraPosition = CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude), zoom: 20);
    markers.add(Marker(markerId: MarkerId(MapMarkerId.userLocation.name), position: initialCameraPosition.target, icon: await _loadCustomIcon('assets/png/map/user.png')));
    _controller?.animateCamera(CameraUpdate.newLatLng(initialCameraPosition.target));
    //* Fetch Destinations
    user = await LocalStorageManager.getUser();
    var data = (await userCollection.doc(user!.uid).get()).data()!;
    destinations = List.from(data[CommonField.selectedZiarat.name]).map((e) => ZiaratModel.fromMap(e)).toList();
    activeZiarat = destinations.first;
    //* First Destination Marker
    markers.add(
      Marker(
        markerId: MarkerId(MapMarkerId.destination.name),
        position: LatLng(activeZiarat!.lat.toDouble(), activeZiarat!.lng.toDouble()),
        icon: await _loadCustomIcon('assets/png/map/destination.png'),
      ),
    );

    notifyListeners();
    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: distanceFilter),
    ).listen((position) => _updateLocation(position, context, ref));
  }

  _updateLocation(Position position, BuildContext context, WidgetRef ref) async {
    markers =
        markers.where((e) => e.markerId.value != MapMarkerId.userLocation.name).toSet()
          ..add(Marker(markerId: MarkerId(MapMarkerId.userLocation.name), position: LatLng(position.latitude, position.longitude), icon: await _loadCustomIcon('assets/png/map/user.png')));
    var distance = Geolocator.distanceBetween(position.latitude, position.longitude, activeZiarat!.lat.toDouble(), activeZiarat!.lng.toDouble());
    if (distance < 20) {
      _positionStream?.cancel();
      await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ReachYourDestinationDialog());
      destinations.removeAt(0);
      await userCollection.doc(user!.uid).set({CommonField.selectedZiarat.name: destinations.map((e) => e.toMap()).toList()}, SetOptions(merge: true));
      if (destinations.isEmpty) {
        _positionStream?.cancel();
        markers = markers.where((e) => e.markerId.value != MapMarkerId.destination.name).toSet();
        notifyListeners();
        await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ZiaratCompleteDialog());
        Navigator.pop(context);
        ref.read(ziaratProvider).reset();
        return;
      } else {
        _positionStream = Geolocator.getPositionStream(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: distanceFilter),
        ).listen((position) => _updateLocation(position, context, ref));
        activeZiarat = destinations.first;
      }
      markers =
          markers.where((e) => e.markerId.value != MapMarkerId.destination.name).toSet()..add(
            Marker(
              markerId: MarkerId(MapMarkerId.destination.name),
              position: LatLng(activeZiarat!.lat.toDouble(), activeZiarat!.lng.toDouble()),
              icon: await _loadCustomIcon('assets/png/map/destination.png'),
            ),
          );
    }
    await _getRoutePolyline(LatLng(position.latitude + 0.000007, position.longitude), LatLng(activeZiarat!.lat.toDouble(), activeZiarat!.lng.toDouble()));
    notifyListeners();
  }

  Future<AssetMapBitmap> _loadCustomIcon(String icon) async {
    return await BitmapDescriptor.asset(ImageConfiguration(size: Size(25, 25)), icon);
  }

  Future<void> _getRoutePolyline(LatLng startPoint, LatLng endPoint) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${startPoint.latitude},${startPoint.longitude}',
      'destination': '${endPoint.latitude},${endPoint.longitude}',
      'mode': 'driving',
      'key': await mapsApiKey,
    });
    log(uri.toString());
    final response = await get(uri);
    var body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['routes'].isNotEmpty) {
      final route = body['routes'].first as Map<String, dynamic>;
      final leg = route['legs'].first;
      activeZiarat = activeZiarat!.copyWith(distance: leg['distance']['text'], time: leg['duration']['text']);
      updateActiveZiarat(activeZiarat: activeZiarat!);
      var steps = leg['steps'] as List;
      for (var step in steps) {
        final points = step['polyline']['points'];
        final List<LatLng> routeCoords = _decodePolyline(points);
        final line = Polyline(polylineId: PolylineId(points), points: routeCoords, color: CColors.primary, width: 5, startCap: Cap.roundCap, endCap: Cap.roundCap);
        polylines = polylines.where((e) => e.polylineId.value != points).toSet()..add(line);
      }
    }
    notifyListeners();
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return polyline;
  }

  Future<void> updateActiveZiarat({required ZiaratModel activeZiarat}) async {
    var data = (await userCollection.doc(user!.uid).get()).data()!;
    destinations = List.from(data[CommonField.selectedZiarat.name]).map((e) => ZiaratModel.fromMap(e)).toList();
    await userCollection.doc(user!.uid).update({CommonField.selectedZiarat.name: destinations.map((e) => e.title == activeZiarat.title ? activeZiarat.toMap() : e.toMap()).toList()});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _positionStream?.cancel();
    super.dispose();
  }
}
