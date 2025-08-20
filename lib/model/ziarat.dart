import '../export.dart';

class ZiaratModel {
  final String title_en;
  final String title_ur;
  final num lat;
  final num lng;
  final String distance;
  final String time;
  final String? detail;
  ZiaratModel({required this.title_en, required this.title_ur, required this.lat, required this.lng, required this.distance, required this.time, this.detail});

  ZiaratModel copyWith({String? title_en, String? title_ur, num? lat, num? lng, String? distance, String? time, String? detail}) {
    return ZiaratModel(
      title_en: title_en ?? this.title_en,
      title_ur: title_ur ?? this.title_ur,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      distance: distance ?? this.distance,
      time: time ?? this.time,
      detail: detail ?? this.detail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title_en': title_en, 'title_ur': title_ur, 'lat': lat, 'lng': lng, if (detail != null) 'detail': detail};
  }

  factory ZiaratModel.fromMap(Map<String, dynamic> map) {
    return ZiaratModel(
      title_en: map['title_en']?.toString() ?? '',
      title_ur: map['title_ur']?.toString() ?? '',
      lat: map['lat'],
      lng: map['lng'],
      distance: map['distance']?.toString() ?? '0 km',
      time: map['time']?.toString() ?? '0 m',
      detail: (map.containsKey('detail')) ? map['detail'] ?? '' : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZiaratModel.fromJson(String source) => ZiaratModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ZiaratModel(title_en: $title_en, title_ur: $title_ur, lat: $lat, lng: $lng, distance: $distance, time: $time, detail: $detail)';
  }

  @override
  bool operator ==(covariant ZiaratModel other) {
    if (identical(this, other)) return true;

    return other.title_en == title_en && other.title_ur == title_ur && other.lat == lat && other.lng == lng && other.distance == distance && other.time == time && other.detail == detail;
  }

  @override
  int get hashCode {
    return title_en.hashCode ^ title_ur.hashCode ^ lat.hashCode ^ lng.hashCode ^ distance.hashCode ^ time.hashCode ^ detail.hashCode;
  }
}
