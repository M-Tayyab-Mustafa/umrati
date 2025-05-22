// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ZiaratModel {
  final String title;
  final num lat;
  final num lng;
  final String distance;
  ZiaratModel({required this.title, required this.lat, required this.lng, required this.distance});

  ZiaratModel copyWith({String? title, num? lat, num? lng, String? distance}) {
    return ZiaratModel(title: title ?? this.title, lat: lat ?? this.lat, lng: lng ?? this.lng, distance: distance ?? this.distance);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'lat': lat, 'lng': lng, 'distance': distance};
  }

  factory ZiaratModel.fromMap(Map<String, dynamic> map) {
    return ZiaratModel(title: map['title']?.toString() ?? '', lat: map['lat'], lng: map['lng'], distance: map['distance']?.toString() ?? '0');
  }

  String toJson() => json.encode(toMap());

  factory ZiaratModel.fromJson(String source) => ZiaratModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ZiaratModel(title: $title, lat: $lat, lng: $lng, distance: $distance)';
  }

  @override
  bool operator ==(covariant ZiaratModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.lat == lat && other.lng == lng && other.distance == distance;
  }

  @override
  int get hashCode {
    return title.hashCode ^ lat.hashCode ^ lng.hashCode ^ distance.hashCode;
  }
}
