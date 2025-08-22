import '../../../export.dart';

final profileProvider = ChangeNotifierProvider.autoDispose<ProfileNotifier>((ref) => ProfileNotifier());

class ProfileNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isStatingPoint = true;
  List<PointsLocation> locations = [];

  void setLocation() async {
    isLoading = true;
    notifyListeners();
    var doc = settingsCollection.doc(CommonDoc.safaMarwaRunningPoints.name);
    if ((await doc.get()).exists) {
      var points = List.from((await doc.get()).get(CommonField.points.name)).map((e) => PointsLocation.fromMap(e)).toList();
      try {
        var position = await Geolocator.getCurrentPosition();
        if (points.last.pointType == 'starting') {
          points.add(PointsLocation(latitude: position.latitude, longitude: position.longitude, pointType: 'ending'));
        } else {
          points.add(PointsLocation(latitude: position.latitude, longitude: position.longitude, pointType: 'starting'));
        }
        doc.update({CommonField.points.name: points.map((e) => e.toMap()).toList()});
      } catch (e) {
        if (kDebugMode) log(e.toString());
        errorToast(e.toString());
      }
    } else {
      try {
        var position = await Geolocator.getCurrentPosition();
        doc.set({
          CommonField.points.name: [PointsLocation(latitude: position.latitude, longitude: position.longitude, pointType: 'starting').toMap()],
        });
      } catch (e) {
        if (kDebugMode) log(e.toString());
        errorToast(e.toString());
      }
    }
    locations = List.from((await doc.get()).get(CommonField.points.name)).map((e) => PointsLocation.fromMap(e)).toList();

    isLoading = false;
    notifyListeners();
  }

  void clear() async {
    isLoading = true;
    notifyListeners();
    var doc = settingsCollection.doc(CommonDoc.safaMarwaRunningPoints.name);
    locations.clear();
    await doc.delete();
    isLoading = false;
    notifyListeners();
  }
}

class PointsLocation {
  final double latitude;
  final double longitude;
  final String pointType;

  PointsLocation({required this.latitude, required this.longitude, required this.pointType});

  PointsLocation copyWith({double? latitude, double? longitude, String? pointType}) {
    return PointsLocation(latitude: latitude ?? this.latitude, longitude: longitude ?? this.longitude, pointType: pointType ?? this.pointType);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'latitude': latitude, 'longitude': longitude, 'pointType': pointType};
  }

  factory PointsLocation.fromMap(Map<String, dynamic> map) {
    return PointsLocation(latitude: map['latitude'] as double, longitude: map['longitude'] as double, pointType: map['pointType'] as String);
  }

  String toJson() => json.encode(toMap());

  factory PointsLocation.fromJson(String source) => PointsLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PointsLocation(latitude: $latitude, longitude: $longitude, pointType: $pointType)';

  @override
  bool operator ==(covariant PointsLocation other) {
    if (identical(this, other)) return true;

    return other.latitude == latitude && other.longitude == longitude && other.pointType == pointType;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ pointType.hashCode;
}
