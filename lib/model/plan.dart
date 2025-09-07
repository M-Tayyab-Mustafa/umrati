// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../export.dart';

class PlanModel {
  final String id;
  final num amount;
  final num discount_amount;
  final String name;
  final int members;
  final String member_count_label;
  final int duration;
  final bool is_heigh_tier;
  final String type;
  final bool has_discount;
  PlanModel({
    required this.id,
    required this.amount,
    required this.discount_amount,
    required this.name,
    required this.members,
    required this.member_count_label,
    required this.duration,
    required this.is_heigh_tier,
    required this.type,
    required this.has_discount,
  });

  PlanModel copyWith({String? id, num? amount, num? discount_amount, String? name, int? members, String? member_count_label, int? duration, bool? is_heigh_tier, String? type, bool? has_discount}) {
    return PlanModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      discount_amount: discount_amount ?? this.discount_amount,
      name: name ?? this.name,
      members: members ?? this.members,
      member_count_label: member_count_label ?? this.member_count_label,
      duration: duration ?? this.duration,
      is_heigh_tier: is_heigh_tier ?? this.is_heigh_tier,
      type: type ?? this.type,
      has_discount: has_discount ?? this.has_discount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'discount_amount': discount_amount,
      'name': name,
      'members': members,
      'member_count_label': member_count_label,
      'duration': duration,
      'is_heigh_tier': is_heigh_tier,
      'type': type,
      'has_discount': has_discount,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'],
      amount: map['amount'],
      discount_amount: map['discount_amount'],
      name: map['name'].toString(),
      members: int.tryParse(map['members'].toString()) ?? 1,
      member_count_label: map['member_count_label']?.toString() ?? '',
      duration: int.tryParse(map['duration'].toString()) ?? 0,
      is_heigh_tier: map['is_heigh_tier'] ?? false,
      type: map['type']?.toString() ?? 'individual',
      has_discount: map['has_discount'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) => PlanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlanModel(id: $id, amount: $amount, discount_amount: $discount_amount, name: $name, members: $members, member_count_label: $member_count_label, duration: $duration, is_heigh_tier: $is_heigh_tier, type: $type, has_discount: $has_discount)';
  }

  @override
  bool operator ==(covariant PlanModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.amount == amount &&
        other.discount_amount == discount_amount &&
        other.name == name &&
        other.members == members &&
        other.member_count_label == member_count_label &&
        other.duration == duration &&
        other.is_heigh_tier == is_heigh_tier &&
        other.type == type &&
        other.has_discount == has_discount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        discount_amount.hashCode ^
        name.hashCode ^
        members.hashCode ^
        member_count_label.hashCode ^
        duration.hashCode ^
        is_heigh_tier.hashCode ^
        type.hashCode ^
        has_discount.hashCode;
  }
}
