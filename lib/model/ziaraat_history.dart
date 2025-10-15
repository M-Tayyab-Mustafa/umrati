import '../export.dart';

class ZiaraatHistoryModel {
  final String uid;
  final String userId;
  final String type;
  final int total;
  final String ziaraatCity;
  final bool isCompleted;
  final List<ZiaraatModel> remainingZiaraats;
  final List<ZiaraatModel> completedZiaraats;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  ZiaraatHistoryModel({
    required this.uid,
    required this.userId,
    required this.type,
    required this.total,
    required this.ziaraatCity,
    required this.isCompleted,
    required this.remainingZiaraats,
    required this.completedZiaraats,
    this.createdAt,
    this.updatedAt,
  });

  ZiaraatHistoryModel copyWith({
    String? uid,
    String? userId,
    String? type,
    int? total,
    String? ziaraatCity,
    bool? isCompleted,
    List<ZiaraatModel>? remainingZiaraats,
    List<ZiaraatModel>? completedZiaraats,
  }) {
    return ZiaraatHistoryModel(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      total: total ?? this.total,
      ziaraatCity: ziaraatCity ?? this.ziaraatCity,
      isCompleted: isCompleted ?? this.isCompleted,
      remainingZiaraats: remainingZiaraats ?? this.remainingZiaraats,
      completedZiaraats: completedZiaraats ?? this.completedZiaraats,
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
      'ziaraat_city': ziaraatCity,
      'is_completed': isCompleted,
      'remaining_ziaraats': remainingZiaraats.map((x) => x.toMap()).toList(),
      'completed_ziaraats': completedZiaraats.map((x) => x.toMap()).toList(),
      'created_at': createdAt ?? this.createdAt?.millisecondsSinceEpoch,
      'updated_at': updatedAt ?? this.updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory ZiaraatHistoryModel.fromMap(Map<String, dynamic> map) {
    return ZiaraatHistoryModel(
      uid: map['uid'] ?? '',
      userId: map['user_id'] ?? '',
      type: map['type'] ?? '',
      total: map['total'] ?? 0,
      ziaraatCity: map['ziaraat_city'] ?? '',
      isCompleted: map['is_completed'] ?? false,
      remainingZiaraats: List<ZiaraatModel>.from(map['remaining_ziaraats'].map<ZiaraatModel>((ziaraat) => ZiaraatModel.fromMap(ziaraat))),
      completedZiaraats: List<ZiaraatModel>.from(map['completed_ziaraats'].map<ZiaraatModel>((ziaraat) => ZiaraatModel.fromMap(ziaraat))),
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

  factory ZiaraatHistoryModel.fromJson(String source) => ZiaraatHistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ZiaraatHistoryModel(uid: $uid, user_id: $userId, type: $type, total: $total, ziaraat_city: $ziaraatCity, is_completed: $isCompleted, remaining_ziaraats: $remainingZiaraats, completed_ziaraats: $completedZiaraats, created_at: $createdAt, updated_at: $updatedAt)';

  @override
  bool operator ==(covariant ZiaraatHistoryModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.uid == uid &&
        other.userId == userId &&
        other.type == type &&
        other.total == total &&
        other.ziaraatCity == ziaraatCity &&
        other.isCompleted == isCompleted &&
        listEquals(other.remainingZiaraats, remainingZiaraats) &&
        listEquals(other.completedZiaraats, completedZiaraats) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      userId.hashCode ^
      type.hashCode ^
      total.hashCode ^
      ziaraatCity.hashCode ^
      isCompleted.hashCode ^
      remainingZiaraats.hashCode ^
      completedZiaraats.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
