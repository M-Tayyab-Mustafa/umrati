import 'dart:convert';

class Country {
  final String icon;
  final String code;
  Country({required this.icon, required this.code});

  Country copyWith({String? icon, String? code}) {
    return Country(icon: icon ?? this.icon, code: code ?? this.code);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'icon': icon, 'code': code};
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(icon: map['icon']?.toString() ?? '', code: map['code']?.toString() ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Country.fromJson(String source) => Country.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Country(icon: $icon, code: $code)';

  @override
  bool operator ==(covariant Country other) {
    if (identical(this, other)) return true;

    return other.icon == icon && other.code == code;
  }

  @override
  int get hashCode => icon.hashCode ^ code.hashCode;
}
