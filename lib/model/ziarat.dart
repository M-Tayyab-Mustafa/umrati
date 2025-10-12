// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../export.dart';

class ZiaraatModel {
  final String title_en;
  final String title_ur;
  final num lat;
  final num lng;
  final String distance;
  final String time;
  final String detail_en;
  final String detail_ur;
  ZiaraatModel({required this.title_en, required this.title_ur, required this.lat, required this.lng, required this.distance, required this.time, required this.detail_en, required this.detail_ur});

  ZiaraatModel copyWith({String? title_en, String? title_ur, num? lat, num? lng, String? distance, String? time, String? detail_en, String? detail_ur}) {
    return ZiaraatModel(
      title_en: title_en ?? this.title_en,
      title_ur: title_ur ?? this.title_ur,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      distance: distance ?? this.distance,
      time: time ?? this.time,
      detail_en: detail_en ?? this.detail_en,
      detail_ur: detail_ur ?? this.detail_ur,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title_en': title_en, 'title_ur': title_ur, 'lat': lat, 'lng': lng, 'distance': distance, 'time': time, 'detail_en': detail_en, 'detail_ur': detail_ur};
  }

  factory ZiaraatModel.fromMap(Map<String, dynamic> map) {
    return ZiaraatModel(
      title_en: map['title_en']?.toString() ?? '',
      title_ur: map['title_ur']?.toString() ?? '',
      lat: map['lat'],
      lng: map['lng'],
      distance: map['distance']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      detail_en: map['detail_en']?.toString() ?? '',
      detail_ur: map['detail_ur']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ZiaraatModel.fromJson(String source) => ZiaraatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ZiaraatModel(title_en: $title_en, title_ur: $title_ur, lat: $lat, lng: $lng, distance: $distance, time: $time, detail_en: $detail_en, detail_ur: $detail_ur)';
  }

  @override
  bool operator ==(covariant ZiaraatModel other) {
    if (identical(this, other)) return true;

    return other.title_en == title_en &&
        other.title_ur == title_ur &&
        other.lat == lat &&
        other.lng == lng &&
        other.distance == distance &&
        other.time == time &&
        other.detail_en == detail_en &&
        other.detail_ur == detail_ur;
  }

  @override
  int get hashCode {
    return title_en.hashCode ^ title_ur.hashCode ^ lat.hashCode ^ lng.hashCode ^ distance.hashCode ^ time.hashCode ^ detail_en.hashCode ^ detail_ur.hashCode;
  }
}
