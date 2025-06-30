// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String gender;
  final bool is_doing_ziarat;
  final String tawaf_circle_count;
  final String? created_at;
  final String? updated_at;
  final _timer = DateTime.now().toIso8601String();

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.gender,
    this.is_doing_ziarat = false,
    this.tawaf_circle_count = '0',
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
    String? tawaf_circle_count,
    String? created_at,
    String? updated_at,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      is_doing_ziarat: is_doing_ziarat ?? this.is_doing_ziarat,
      tawaf_circle_count: tawaf_circle_count ?? this.tawaf_circle_count,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'is_doing_ziarat': is_doing_ziarat,
      'tawaf_circle_count': tawaf_circle_count,
      'created_at': created_at ?? _timer,
      'updated_at': updated_at ?? _timer,
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
      tawaf_circle_count: map['tawaf_circle_count']?.toString() ?? '0',
      created_at: map['created_at']?.toString() ?? '',
      updated_at: map['updated_at']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, phone: $phone, photo: $photo, gender: $gender, tawaf_circle_count: $tawaf_circle_count, is_doing_ziarat: $is_doing_ziarat, created_at: $created_at, updated_at: $updated_at)';
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
        other.tawaf_circle_count == tawaf_circle_count &&
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
        tawaf_circle_count.hashCode ^
        is_doing_ziarat.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
