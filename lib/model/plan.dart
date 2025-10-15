import '../export.dart';

class PlanModel {
  final String id;
  final num amount;
  final num discount_amount;
  final String name_en;
  final String name_ur;
  final int members;
  final String member_count_label;
  final int duration;
  final List<String> regions;
  final String type;
  final bool has_discount;

  PlanModel({
    required this.id,
    required this.amount,
    required this.discount_amount,
    required this.name_en,
    required this.name_ur,
    required this.members,
    required this.member_count_label,
    required this.duration,
    required this.regions,
    required this.type,
    required this.has_discount,
  });

  PlanModel copyWith({
    String? id,
    num? amount,
    num? discount_amount,
    String? name_en,
    String? name_ur,
    int? members,
    String? member_count_label,
    int? duration,
    List<String>? regions,
    String? type,
    bool? has_discount,
  }) {
    return PlanModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      discount_amount: discount_amount ?? this.discount_amount,
      name_en: name_en ?? this.name_en,
      name_ur: name_ur ?? this.name_ur,
      members: members ?? this.members,
      member_count_label: member_count_label ?? this.member_count_label,
      duration: duration ?? this.duration,
      regions: regions ?? this.regions,
      type: type ?? this.type,
      has_discount: has_discount ?? this.has_discount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'discount_amount': discount_amount,
      'name_en': name_en,
      'name_ur': name_ur,
      'members': members,
      'member_count_label': member_count_label,
      'duration': duration,
      'regions': regions,
      'type': type,
      'has_discount': has_discount,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'],
      amount: map['amount'],
      discount_amount: map['discount_amount'],
      name_en: map['name_en'].toString(),
      name_ur: map['name_ur'].toString(),
      members: int.tryParse(map['members'].toString()) ?? 1,
      member_count_label: map['member_count_label']?.toString() ?? '',
      duration: int.tryParse(map['duration'].toString()) ?? 0,
      regions: List<String>.from(map['regions']),
      type: map['type']?.toString() ?? 'individual',
      has_discount: map['has_discount'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) => PlanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlanModel(id: $id, amount: $amount, discount_amount: $discount_amount, name_en: $name_en, name_ur: $name_ur, members: $members, member_count_label: $member_count_label, duration: $duration, regions: $regions, type: $type, has_discount: $has_discount)';
  }

  @override
  bool operator ==(covariant PlanModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.amount == amount &&
        other.discount_amount == discount_amount &&
        other.name_en == name_en &&
        other.name_ur == name_ur &&
        other.members == members &&
        other.member_count_label == member_count_label &&
        other.duration == duration &&
        listEquals(other.regions, regions) &&
        other.type == type &&
        other.has_discount == has_discount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        discount_amount.hashCode ^
        name_en.hashCode ^
        name_ur.hashCode ^
        members.hashCode ^
        member_count_label.hashCode ^
        duration.hashCode ^
        regions.hashCode ^
        type.hashCode ^
        has_discount.hashCode;
  }
}
