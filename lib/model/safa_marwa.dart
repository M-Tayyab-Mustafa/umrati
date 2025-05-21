// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SafaMarwaModel {
  final String distance;
  final String unit;
  final String threshold;
  final String safaLat;
  final String safaLng;
  final String marwaLat;
  final String marwaLng;
  SafaMarwaModel({required this.distance, required this.unit, required this.threshold, required this.safaLat, required this.safaLng, required this.marwaLat, required this.marwaLng});

  SafaMarwaModel copyWith({String? distance, String? unit, String? threshold, String? safaLat, String? safaLng, String? marwaLat, String? marwaLng}) {
    return SafaMarwaModel(
      distance: distance ?? this.distance,
      unit: unit ?? this.unit,
      threshold: threshold ?? this.threshold,
      safaLat: safaLat ?? this.safaLat,
      safaLng: safaLng ?? this.safaLng,
      marwaLat: marwaLat ?? this.marwaLat,
      marwaLng: marwaLng ?? this.marwaLng,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'distance': distance, 'unit': unit, 'threshold': threshold, 'safaLat': safaLat, 'safaLng': safaLng, 'marwaLat': marwaLat, 'marwaLng': marwaLng};
  }

  factory SafaMarwaModel.fromMap(Map<String, dynamic> map) {
    return SafaMarwaModel(
      distance: map['distance']?.toString() ?? '',
      unit: map['unit']?.toString() ?? '',
      threshold: map['threshold']?.toString() ?? '',
      safaLat: map['safaLat']?.toString() ?? '',
      safaLng: map['safaLng']?.toString() ?? '',
      marwaLat: map['marwaLat']?.toString() ?? '',
      marwaLng: map['marwaLng']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SafaMarwaModel.fromJson(String source) => SafaMarwaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SafaMarwaModel(distance: $distance, unit: $unit, threshold: $threshold, safaLat: $safaLat, safaLng: $safaLng, marwaLat: $marwaLat, marwaLng: $marwaLng)';
  }

  @override
  bool operator ==(covariant SafaMarwaModel other) {
    if (identical(this, other)) return true;

    return other.distance == distance &&
        other.unit == unit &&
        other.threshold == threshold &&
        other.safaLat == safaLat &&
        other.safaLng == safaLng &&
        other.marwaLat == marwaLat &&
        other.marwaLng == marwaLng;
  }

  @override
  int get hashCode {
    return distance.hashCode ^ unit.hashCode ^ threshold.hashCode ^ safaLat.hashCode ^ safaLng.hashCode ^ marwaLat.hashCode ^ marwaLng.hashCode;
  }
}
