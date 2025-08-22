// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../export.dart';

class PlanModel {
  final String id;
  final num duration;
  final num amount;
  PlanModel({required this.id, required this.duration, required this.amount});

  PlanModel copyWith({String? id, num? duration, num? amount}) {
    return PlanModel(id: id ?? this.id, duration: duration ?? this.duration, amount: amount ?? this.amount);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'duration': duration, 'amount': amount};
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(id: map['id'].toString(), duration: map['duration'], amount: map['amount']);
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) => PlanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PlanModel(id: $id, duration: $duration, amount: $amount)';

  @override
  bool operator ==(covariant PlanModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.duration == duration && other.amount == amount;
  }

  @override
  int get hashCode => id.hashCode ^ duration.hashCode ^ amount.hashCode;
}
