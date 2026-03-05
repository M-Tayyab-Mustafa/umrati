import '../export.dart';

class OTPModel {
  final String otpCode;
  final Timestamp? expiredAt;
  OTPModel({required this.otpCode, this.expiredAt});

  OTPModel copyWith({String? otpCode, Timestamp? expiredAt}) {
    return OTPModel(otpCode: otpCode ?? this.otpCode, expiredAt: expiredAt ?? this.expiredAt);
  }

  Map<String, dynamic> toMap({FieldValue? expiredAt}) {
    return <String, dynamic>{'otp_code': otpCode, 'expired_at': expiredAt ?? this.expiredAt?.millisecondsSinceEpoch};
  }

  factory OTPModel.fromMap(Map<String, dynamic> map) {
    return OTPModel(otpCode: map['otp_code'] as String, expiredAt: map['expired_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['expired_at']) : map['expired_at']);
  }

  String toJson({FieldValue? expiredAt}) => json.encode(toMap(expiredAt: expiredAt));

  factory OTPModel.fromJson(String source) => OTPModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OTPModel(otp_code: $otpCode, expired_at: $expiredAt)';

  @override
  bool operator ==(covariant OTPModel other) {
    if (identical(this, other)) return true;

    return other.otpCode == otpCode && other.expiredAt == expiredAt;
  }

  @override
  int get hashCode => otpCode.hashCode ^ expiredAt.hashCode;
}
