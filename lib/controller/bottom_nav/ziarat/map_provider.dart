import '../../../export.dart';
import '../../../view/bottom_nav/home/ziarat/page.dart';

final mapPageProvider = ChangeNotifierProvider.autoDispose<MapPageNotifier>((ref) => MapPageNotifier());

class MapPageNotifier extends ChangeNotifier {
  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext value) => _context = value;

  WidgetRef? _ref;
  WidgetRef get ref => _ref!;
  set ref(WidgetRef value) => _ref = value;

  GoogleMapController? _controller;
  StreamSubscription<Position>? _positionStream;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  UserModel? user;
  final LayerLink layerLink = LayerLink();
  OverlayEntry? overlayEntry;
  final FlutterTts flutterTts = FlutterTts();
  bool isListening = false;
  var bottomSheetSize = screenSize.height * 0.13;
  ZiaratModel? activeZiarat;
  List<ZiaratModel> destinations = [];
  ZiaratHistoryModel? history;
  get panelController => SlidingUpPanelController();

  set mapController(GoogleMapController? controller) {
    _controller = controller;
    notifyListeners();
  }

  CameraPosition initialCameraPosition = CameraPosition(target: LatLng(30.17271735209673, 71.45729802421867), zoom: 20);

  Future<void> initialization({ZiaratHistoryModel? ziaratHistory}) async {
    try {
      var currentPosition = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
      initialCameraPosition = CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude), zoom: 20);
      markers.add(Marker(markerId: MarkerId(MapMarkerId.userLocation.name), position: initialCameraPosition.target, icon: await _loadCustomIcon('assets/png/map/user.png')));
      _controller?.animateCamera(CameraUpdate.newLatLng(initialCameraPosition.target));
      user = await LocalStorageManager.getUser();
      if (ziaratHistory == null) {
        var query = await historyCollection
            .where(Filter.and(Filter('user_id', isEqualTo: user!.uid), Filter('type', isEqualTo: UserActivityType.ziarat.name), Filter('is_completed', isEqualTo: false)))
            .get()
            .timeout(const Duration(seconds: Helper.timeOutTime), onTimeout: () => throw Helper.timeoutError);
        if (query.docs.isEmpty) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ZiaratPage()));
          return;
        }
        history = ZiaratHistoryModel.fromMap(query.docs.first.data());
      } else {
        history = ziaratHistory;
      }

      destinations = history!.remainingZiarats;
      activeZiarat = history!.remainingZiarats.first;
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
      ).listen((position) => _updateLocation(position));
    } catch (e) {
      if (kDebugMode) log(e.toString());
      errorToast(e.toString());
    }
  }

  Future<void> _updateLocation(Position position) async {
    markers =
        markers.where((e) => e.markerId.value != MapMarkerId.userLocation.name).toSet()
          ..add(Marker(markerId: MarkerId(MapMarkerId.userLocation.name), position: LatLng(position.latitude, position.longitude), icon: await _loadCustomIcon('assets/png/map/user.png')));
    var distance = Geolocator.distanceBetween(position.latitude, position.longitude, activeZiarat!.lat.toDouble(), activeZiarat!.lng.toDouble());
    if (distance < 20) {
      _positionStream?.cancel();
      await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ReachYourDestinationDialog());
      destinations.removeAt(0);
      history = history!.copyWith(remainingZiarats: destinations, completedZiarats: [...history!.completedZiarats, activeZiarat!]);
      await historyCollection.doc(history!.uid).update(history!.toMap(updatedAt: FieldValue.serverTimestamp()));
      if (destinations.isEmpty) {
        _positionStream?.cancel();
        markers = markers.where((e) => e.markerId.value != MapMarkerId.destination.name).toSet();
        notifyListeners();
        await showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => ZiaratCompleteDialog());
        Navigator.pop(context);
        return ref.read(ziaratProvider.notifier).reset();
      } else {
        activeZiarat = destinations.first;
        _positionStream = Geolocator.getPositionStream(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: distanceFilter),
        ).listen((position) => _updateLocation(position));
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
    if (context.mounted) notifyListeners();
  }

  Future<AssetMapBitmap> _loadCustomIcon(String icon) async => await BitmapDescriptor.asset(ImageConfiguration(size: Size(25, 25)), icon);

  Future<void> _getRoutePolyline(LatLng startPoint, LatLng endPoint) async {
    final leg = await Helper.getRouteLeg(startPoint: startPoint, endPoint: endPoint);
    if (leg != null) {
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
    await userCollection.doc(user!.uid).update({CommonField.selectedZiarat.name: destinations.map((e) => e.title_en == activeZiarat.title_en ? activeZiarat.toMap() : e.toMap()).toList()});
  }

  Future<void> showMoreOptions({required BuildContext context}) async {
    overlayEntry = OverlayEntry(
      canSizeOverlay: true,
      builder:
          (context) => Center(
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 130,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF212029), borderRadius: BorderRadius.circular(32)),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.ziarat_history.tr(), style: CTextStyle.w500(fontSize: 11, color: Colors.white)),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 20),
                          child: GestureDetector(
                            onTap: () {
                              hideMoreOptions();
                            },
                            child: Row(
                              children: [
                                CustomImage(path: 'assets/svg/ziarat/listen.svg', imageType: ImageType.svg, size: 22, margin: EdgeInsets.only(right: 10)),
                                Text(LocaleKeys.listen.tr(), style: CTextStyle.w900(fontSize: 14, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              hideMoreOptions();
                              showDialog(context: context, builder: (context) => ZiaratReadingDetailDialog(ziarat: activeZiarat!));
                            },
                            child: Row(
                              children: [
                                CustomImage(path: 'assets/svg/ziarat/read.svg', imageType: ImageType.svg, size: 24, margin: EdgeInsets.only(right: 10)),
                                Text(LocaleKeys.read.tr(), style: CTextStyle.w900(fontSize: 14, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void hideMoreOptions() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void startListing(String detail) async {
    //Todo:: In Next Version
    // await flutterTts.speak(detail);
    // isListening = true;
    // notifyListeners();
  }

  void stopListing() async {
    await flutterTts.stop();
    isListening = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    hideMoreOptions();
    _positionStream?.cancel();
    super.dispose();
  }
}
