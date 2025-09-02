// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../export.dart';

class PlanModel {
  final String id;
  final num amount;
  final int members;
  final int duration;
  final bool is_heigh_tier;
  final String type;
  PlanModel({required this.id, required this.amount, required this.members, required this.duration, required this.is_heigh_tier, required this.type});

  PlanModel copyWith({String? id, num? amount, int? members, int? duration, bool? is_heigh_tier, String? type}) {
    return PlanModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      members: members ?? this.members,
      duration: duration ?? this.duration,
      is_heigh_tier: is_heigh_tier ?? this.is_heigh_tier,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'amount': amount, 'members': members, 'duration': duration, 'is_heigh_tier': is_heigh_tier, 'type': type};
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'].toString(),
      amount: map['amount'] as num,
      members: int.tryParse(map['members'].toString()) ?? 1,
      duration: int.tryParse(map['duration'].toString()) ?? 0,
      is_heigh_tier: map['is_heigh_tier'] ?? false,
      type: map['type'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) => PlanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlanModel(id: $id, amount: $amount, members: $members, duration: $duration, is_heigh_tier: $is_heigh_tier, type: $type)';
  }

  @override
  bool operator ==(covariant PlanModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.amount == amount && other.members == members && other.duration == duration && other.is_heigh_tier == is_heigh_tier && other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ amount.hashCode ^ members.hashCode ^ duration.hashCode ^ is_heigh_tier.hashCode ^ type.hashCode;
  }
}
