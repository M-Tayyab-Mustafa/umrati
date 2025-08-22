import '../export.dart';

class SubscriptionModel {
  final bool isFreeSubscribed;
  final Timestamp? created_at;
  final Timestamp? expire_at;
  final Timestamp? updated_at;
  SubscriptionModel({required this.isFreeSubscribed, this.created_at, this.expire_at, this.updated_at});

  SubscriptionModel copyWith({bool? isFreeSubscribed, Timestamp? created_at, Timestamp? expire_at, Timestamp? updated_at}) {
    return SubscriptionModel(
      isFreeSubscribed: isFreeSubscribed ?? this.isFreeSubscribed,
      created_at: created_at ?? this.created_at,
      expire_at: expire_at ?? this.expire_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap({FieldValue? created_at, FieldValue? expire_at, FieldValue? updated_at}) {
    return <String, dynamic>{
      'isFreeSubscribed': isFreeSubscribed,
      'created_at': created_at ?? this.created_at?.millisecondsSinceEpoch,
      'expire_at': expire_at ?? this.expire_at?.millisecondsSinceEpoch,
      'updated_at': updated_at ?? this.updated_at?.millisecondsSinceEpoch,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      isFreeSubscribed: map['isFreeSubscribed'] as bool,
      created_at: map['created_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['created_at']) : map['created_at'],
      updated_at: map['updated_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['updated_at']) : map['updated_at'],
      expire_at: map['expire_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['expire_at']) : map['expire_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) => SubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubscriptionModel(isFreeSubscribed: $isFreeSubscribed, created_at: $created_at, expire_at: $expire_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant SubscriptionModel other) {
    if (identical(this, other)) return true;

    return other.isFreeSubscribed == isFreeSubscribed && other.created_at == created_at && other.expire_at == expire_at && other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return isFreeSubscribed.hashCode ^ created_at.hashCode ^ expire_at.hashCode ^ updated_at.hashCode;
  }
}
