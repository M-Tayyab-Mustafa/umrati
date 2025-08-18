// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ZiaratModel {
  final String title;
  final num lat;
  final num lng;
  final String distance;
  final String time;
  final String? detail;
  ZiaratModel({required this.title, required this.lat, required this.lng, required this.distance, required this.time, this.detail});

  ZiaratModel copyWith({String? title, num? lat, num? lng, String? distance, String? time, String? detail}) {
    return ZiaratModel(title: title ?? this.title, lat: lat ?? this.lat, lng: lng ?? this.lng, distance: distance ?? this.distance, time: time ?? this.time, detail: detail ?? this.detail);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'lat': lat, 'lng': lng, 'distance': distance, 'time': time, if (detail != null) 'detail': detail};
  }

  factory ZiaratModel.fromMap(Map<String, dynamic> map) {
    return ZiaratModel(
      title: map['title']?.toString() ?? '',
      lat: map['lat'],
      lng: map['lng'],
      distance: map['distance']?.toString() ?? '',
      time: map['time']?.toString() ?? '0 m',
      detail: (map.containsKey('detail')) ? map['detail'] ?? '' : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZiaratModel.fromJson(String source) => ZiaratModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ZiaratModel(title: $title, lat: $lat, lng: $lng, distance: $distance, time: $time, detail: $detail)';
  }

  @override
  bool operator ==(covariant ZiaratModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.lat == lat && other.lng == lng && other.distance == distance && other.time == time && other.detail == detail;
  }

  @override
  int get hashCode {
    return title.hashCode ^ lat.hashCode ^ lng.hashCode ^ distance.hashCode ^ time.hashCode ^ detail.hashCode;
  }
}
