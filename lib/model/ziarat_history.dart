import '../export.dart';

class ZiaratHistoryModel {
  final String uid;
  final String userId;
  final String type;
  final int total;
  final String ziaratCity;
  final bool isCompleted;
  final List<ZiaratModel> remainingZiarats;
  final List<ZiaratModel> completedZiarats;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  ZiaratHistoryModel({
    required this.uid,
    required this.userId,
    required this.type,
    required this.total,
    required this.ziaratCity,
    required this.isCompleted,
    required this.remainingZiarats,
    required this.completedZiarats,
    this.createdAt,
    this.updatedAt,
  });

  ZiaratHistoryModel copyWith({
    String? uid,
    String? userId,
    String? type,
    int? total,
    String? ziaratCity,
    bool? isCompleted,
    List<ZiaratModel>? remainingZiarats,
    List<ZiaratModel>? completedZiarats,
  }) {
    return ZiaratHistoryModel(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      total: total ?? this.total,
      ziaratCity: ziaratCity ?? this.ziaratCity,
      isCompleted: isCompleted ?? this.isCompleted,
      remainingZiarats: remainingZiarats ?? this.remainingZiarats,
      completedZiarats: completedZiarats ?? this.completedZiarats,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap({FieldValue? createdAt, FieldValue? updatedAt}) {
    return <String, dynamic>{
      'uid': uid,
      'user_id': userId,
      'type': type,
      'total': total,
      'ziarat_city': ziaratCity,
      'is_completed': isCompleted,
      'remainingZiarats': remainingZiarats.map((x) => x.toMap()).toList(),
      'completedZiarats': completedZiarats.map((x) => x.toMap()).toList(),
      'created_at': createdAt ?? this.createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt ?? this.updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory ZiaratHistoryModel.fromMap(Map<String, dynamic> map) {
    return ZiaratHistoryModel(
      uid: map['uid'] ?? '',
      userId: map['user_id'] ?? '',
      type: map['type'] ?? '',
      total: map['total'] ?? 0,
      ziaratCity: map['ziarat_city'] ?? '',
      isCompleted: map['is_completed'] ?? false,
      remainingZiarats: List<ZiaratModel>.from(map['remainingZiarats'].map<ZiaratModel>((ziarat) => ZiaratModel.fromMap(ziarat))),
      completedZiarats: List<ZiaratModel>.from(map['completedZiarats'].map<ZiaratModel>((ziarat) => ZiaratModel.fromMap(ziarat))),
      createdAt:
          map['created_at'] != null
              ? map['created_at'].runtimeType == Timestamp
                  ? map['created_at']
                  : Timestamp.fromMillisecondsSinceEpoch(map['created_at'])
              : null,
      updatedAt:
          map['updated_at'] != null
              ? map['updated_at'].runtimeType == Timestamp
                  ? map['updated_at']
                  : Timestamp.fromMillisecondsSinceEpoch(map['updated_at'])
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZiaratHistoryModel.fromJson(String source) => ZiaratHistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ZiaratHistoryModel(uid: $uid, user_id: $userId, type: $type, total: $total, ziarat_city: $ziaratCity, is_completed: $isCompleted, remainingZiarats: $remainingZiarats, completedZiarats: $completedZiarats, created_at: $createdAt, updated_at: $updatedAt)';

  @override
  bool operator ==(covariant ZiaratHistoryModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.uid == uid &&
        other.userId == userId &&
        other.type == type &&
        other.total == total &&
        other.ziaratCity == ziaratCity &&
        other.isCompleted == isCompleted &&
        listEquals(other.remainingZiarats, remainingZiarats) &&
        listEquals(other.completedZiarats, completedZiarats) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      userId.hashCode ^
      type.hashCode ^
      total.hashCode ^
      ziaratCity.hashCode ^
      isCompleted.hashCode ^
      remainingZiarats.hashCode ^
      completedZiarats.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
