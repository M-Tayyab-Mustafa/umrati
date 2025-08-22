import '../export.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String gender;
  final bool is_doing_ziarat;
  final int tawafCircleCount;
  final int saiRoundCount;
  final bool isOneSideSaiRunCompleted;
  final SubscriptionModel? subscription;
  final Timestamp? created_at;
  final Timestamp? updated_at;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.gender,
    this.is_doing_ziarat = false,
    this.isOneSideSaiRunCompleted = false,
    this.subscription,
    this.tawafCircleCount = 0,
    this.saiRoundCount = 0,
    this.created_at,
    this.updated_at,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photo,
    String? gender,
    bool? is_doing_ziarat,
    bool? isOneSideSaiRunCompleted,
    int? tawafCircleCount,
    SubscriptionModel? subscription,
    int? saiRoundCount,
    Timestamp? created_at,
    Timestamp? updated_at,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      is_doing_ziarat: is_doing_ziarat ?? this.is_doing_ziarat,
      tawafCircleCount: tawafCircleCount ?? this.tawafCircleCount,
      isOneSideSaiRunCompleted: isOneSideSaiRunCompleted ?? this.isOneSideSaiRunCompleted,
      saiRoundCount: saiRoundCount ?? this.saiRoundCount,
      subscription: subscription ?? this.subscription,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap({FieldValue? created_at, FieldValue? updated_at, FieldValue? subscription_created_at, FieldValue? subscription_expire_at, FieldValue? subscription_updated_at}) {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'is_doing_ziarat': is_doing_ziarat,
      'tawaf_circle_count': tawafCircleCount,
      'subscription': subscription?.toMap(created_at: subscription_created_at, expire_at: subscription_expire_at, updated_at: subscription_updated_at),
      'is_one_side_sai_run_completed': isOneSideSaiRunCompleted,
      'sai_round_count': saiRoundCount,
      'created_at': created_at ?? this.created_at?.millisecondsSinceEpoch,
      'updated_at': updated_at ?? this.updated_at?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      photo: map['photo']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      is_doing_ziarat: map['is_doing_ziarat'] ?? false,
      subscription: map['subscription'] != null ? SubscriptionModel.fromMap(map['subscription']) : SubscriptionModel(isFreeSubscribed: true),
      isOneSideSaiRunCompleted: map['is_one_side_sai_run_completed'] ?? false,
      tawafCircleCount: map['tawaf_circle_count'] ?? 0,
      saiRoundCount: map['sai_round_count'] ?? 0,
      created_at: map['created_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['created_at']) : map['created_at'],
      updated_at: map['updated_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['updated_at']) : map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, phone: $phone, photo: $photo, gender: $gender, tawaf_circle_count: $tawafCircleCount, sai_round_count: $saiRoundCount, is_one_side_sai_run_completed: $isOneSideSaiRunCompleted, subscription: $subscription is_doing_ziarat: $is_doing_ziarat, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.photo == photo &&
        other.gender == gender &&
        other.isOneSideSaiRunCompleted == isOneSideSaiRunCompleted &&
        other.tawafCircleCount == tawafCircleCount &&
        other.subscription == subscription &&
        other.saiRoundCount == saiRoundCount &&
        other.is_doing_ziarat == is_doing_ziarat &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        gender.hashCode ^
        isOneSideSaiRunCompleted.hashCode ^
        tawafCircleCount.hashCode ^
        subscription.hashCode ^
        saiRoundCount.hashCode ^
        is_doing_ziarat.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
