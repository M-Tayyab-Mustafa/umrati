import '../export.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String country_code;
  final String phone;
  final String photo;
  final String gender;
  final bool is_doing_ziarat;
  final String? subscription_id;
  final Timestamp? created_at;
  final Timestamp? updated_at;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.country_code,
    required this.phone,
    required this.photo,
    required this.gender,
    this.is_doing_ziarat = false,
    this.subscription_id,
    this.created_at,
    this.updated_at,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? country_code,
    String? phone,
    String? photo,
    String? gender,
    bool? is_doing_ziarat,
    String? subscription_id,
    Timestamp? created_at,
    Timestamp? updated_at,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      country_code: country_code ?? this.country_code,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      is_doing_ziarat: is_doing_ziarat ?? this.is_doing_ziarat,
      subscription_id: subscription_id ?? this.subscription_id,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap({FieldValue? created_at, FieldValue? updated_at}) {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'country_code': country_code,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'is_doing_ziarat': is_doing_ziarat,
      'subscription_id': subscription_id,
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
      country_code: map['country_code']?.toString() ?? '',
      photo: map['photo']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      is_doing_ziarat: map['is_doing_ziarat'] ?? false,
      subscription_id: map['subscription_id']?.toString() ?? '',
      created_at: map['created_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['created_at']) : map['created_at'],
      updated_at: map['updated_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['updated_at']) : map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, phone: $phone, country_code: $country_code, photo: $photo, gender: $gender, subscription_id: $subscription_id is_doing_ziarat: $is_doing_ziarat, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.country_code == country_code &&
        other.photo == photo &&
        other.gender == gender &&
        other.subscription_id == subscription_id &&
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
        country_code.hashCode ^
        photo.hashCode ^
        gender.hashCode ^
        subscription_id.hashCode ^
        is_doing_ziarat.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
