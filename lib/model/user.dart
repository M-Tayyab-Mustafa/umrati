// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final bool is_tawaf_completed;
  final bool is_safa_marwa_run_completed;
  final String created_at;
  final String updated_at;
  final String gender;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.is_tawaf_completed,
    required this.is_safa_marwa_run_completed,
    required this.created_at,
    required this.updated_at,
    required this.gender,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photo,
    bool? is_tawaf_completed,
    bool? is_safa_marwa_run_completed,
    String? created_at,
    String? updated_at,
    String? gender,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      is_tawaf_completed: is_tawaf_completed ?? this.is_tawaf_completed,
      is_safa_marwa_run_completed: is_safa_marwa_run_completed ?? this.is_safa_marwa_run_completed,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'is_tawaf_completed': is_tawaf_completed,
      'is_safa_marwa_run_completed': is_safa_marwa_run_completed,
      'created_at': created_at,
      'updated_at': updated_at,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      photo: map['photo']?.toString() ?? '',
      is_tawaf_completed: map['is_tawaf_completed'] ?? false,
      is_safa_marwa_run_completed: map['is_safa_marwa_run_completed'] ?? false,
      created_at: map['created_at']?.toString() ?? '',
      updated_at: map['updated_at']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, phone: $phone, photo: $photo, is_tawaf_completed: $is_tawaf_completed, is_safa_marwa_run_completed: $is_safa_marwa_run_completed, created_at: $created_at, updated_at: $updated_at, gender: $gender)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.photo == photo &&
        other.is_tawaf_completed == is_tawaf_completed &&
        other.is_safa_marwa_run_completed == is_safa_marwa_run_completed &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        is_tawaf_completed.hashCode ^
        is_safa_marwa_run_completed.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        gender.hashCode;
  }
}
