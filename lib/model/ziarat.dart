// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ZiaratModel {
  final String title;
  final String lat;
  final String lng;
  ZiaratModel({required this.title, required this.lat, required this.lng});

  ZiaratModel copyWith({String? title, String? lat, String? lng}) {
    return ZiaratModel(title: title ?? this.title, lat: lat ?? this.lat, lng: lng ?? this.lng);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'lat': lat, 'lng': lng};
  }

  factory ZiaratModel.fromMap(Map<String, dynamic> map) {
    return ZiaratModel(title: map['title']?.toString() ?? '', lat: map['lat']?.toString() ?? '', lng: map['lng']?.toString() ?? '');
  }

  String toJson() => json.encode(toMap());

  factory ZiaratModel.fromJson(String source) => ZiaratModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ZiaratModel(title: $title, lat: $lat, lng: $lng)';

  @override
  bool operator ==(covariant ZiaratModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.lat == lat && other.lng == lng;
  }

  @override
  int get hashCode => title.hashCode ^ lat.hashCode ^ lng.hashCode;
}
