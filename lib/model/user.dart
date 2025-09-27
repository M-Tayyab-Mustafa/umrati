import '../export.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String country_code;
  final String phone;
  final String photo;
  final String gender;
  final String password;
  final num total_umra_done;
  final bool is_premium;
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
    required this.password,
    this.is_premium = false,
    this.total_umra_done = 0,
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
    String? password,
    bool? is_premium,
    num? total_umra_done,
    String? subscription_id,
    Timestamp? created_at,
    Timestamp? updated_at,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      is_premium: is_premium ?? this.is_premium,
      country_code: country_code ?? this.country_code,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      total_umra_done: total_umra_done ?? this.total_umra_done,
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
      'is_premium': is_premium,
      'country_code': country_code,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'password': password,
      'total_umra_done': total_umra_done,
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
      is_premium: map['is_premium'] ?? false,
      country_code: map['country_code']?.toString() ?? '',
      photo: map['photo']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      total_umra_done: map['total_umra_done'] ?? 0,
      subscription_id: map['subscription_id']?.toString() ?? '',
      created_at: map['created_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['created_at']) : map['created_at'],
      updated_at: map['updated_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['updated_at']) : map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, is_premium: $is_premium, password: $password, phone: $phone, country_code: $country_code, photo: $photo, gender: $gender, total_umra_done: $total_umra_done, subscription_id: $subscription_id, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.is_premium == is_premium &&
        other.country_code == country_code &&
        other.photo == photo &&
        other.gender == gender &&
        other.password == password &&
        other.total_umra_done == total_umra_done &&
        other.subscription_id == subscription_id &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        is_premium.hashCode ^
        country_code.hashCode ^
        photo.hashCode ^
        gender.hashCode ^
        password.hashCode ^
        total_umra_done.hashCode ^
        subscription_id.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
