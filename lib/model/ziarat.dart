// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ZiaratModel {
  final String title;
  final num lat;
  final num lng;
  final String distance;
  final String time;
  ZiaratModel({required this.title, required this.lat, required this.lng, required this.distance, required this.time});

  ZiaratModel copyWith({String? title, num? lat, num? lng, String? distance, String? time}) {
    return ZiaratModel(title: title ?? this.title, lat: lat ?? this.lat, lng: lng ?? this.lng, distance: distance ?? this.distance, time: time ?? this.time);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'lat': lat, 'lng': lng, 'distance': distance, 'time': time};
  }

  factory ZiaratModel.fromMap(Map<String, dynamic> map) {
    return ZiaratModel(title: map['title']?.toString() ?? '', lat: map['lat'], lng: map['lng'], distance: map['distance']?.toString() ?? '', time: map['time']?.toString() ?? '0 m');
  }

  String toJson() => json.encode(toMap());

  factory ZiaratModel.fromJson(String source) => ZiaratModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ZiaratModel(title: $title, lat: $lat, lng: $lng, distance: $distance, time: $time)';
  }

  @override
  bool operator ==(covariant ZiaratModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.lat == lat && other.lng == lng && other.distance == distance && other.time == time;
  }

  @override
  int get hashCode {
    return title.hashCode ^ lat.hashCode ^ lng.hashCode ^ distance.hashCode ^ time.hashCode;
  }
}
