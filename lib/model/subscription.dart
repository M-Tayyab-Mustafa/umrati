import '../export.dart';

class SubscriptionModel {
  final String uid;
  final List<String> user_ids;
  final PlanModel plan;
  final Timestamp? created_at;
  final Timestamp? expire_at;
  final Timestamp? updated_at;
  SubscriptionModel({required this.uid, required this.user_ids, required this.plan, this.created_at, this.expire_at, this.updated_at});

  SubscriptionModel copyWith({String? uid, List<String>? user_ids, PlanModel? plan, Timestamp? created_at, Timestamp? expire_at, Timestamp? updated_at}) {
    return SubscriptionModel(
      uid: uid ?? this.uid,
      user_ids: user_ids ?? this.user_ids,
      plan: plan ?? this.plan,
      created_at: created_at ?? this.created_at,
      expire_at: expire_at ?? this.expire_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap({FieldValue? created_at, FieldValue? expire_at, FieldValue? updated_at}) {
    return <String, dynamic>{
      'uid': uid,
      'user_ids': user_ids,
      'plan': plan.toMap(),
      'created_at': created_at ?? this.created_at?.millisecondsSinceEpoch,
      'expire_at': expire_at ?? this.expire_at?.millisecondsSinceEpoch,
      'updated_at': updated_at ?? this.updated_at?.millisecondsSinceEpoch,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      uid: map['uid'] ?? '',
      user_ids: List<String>.from(map['user_ids'] ?? []),
      plan: PlanModel.fromMap(map['plan'] as Map<String, dynamic>),
      created_at: map['created_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['created_at']) : map['created_at'],
      updated_at: map['updated_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['updated_at']) : map['updated_at'],
      expire_at: map['expire_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['expire_at']) : map['expire_at'],
    );
  }
  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) => SubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubscriptionModel(uid: $uid, user_ids: $user_ids, plan: $plan, created_at: $created_at, expire_at: $expire_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant SubscriptionModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.user_ids == user_ids && other.plan == plan && other.created_at == created_at && other.expire_at == expire_at && other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ user_ids.hashCode ^ plan.hashCode ^ created_at.hashCode ^ expire_at.hashCode ^ updated_at.hashCode;
  }
}
