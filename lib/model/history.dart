import '../export.dart';

class HistoryModel {
  final String uid;
  final String user_id;
  final String type;
  final bool is_doing;
  final bool has_done_before_meeqaat_tasks;
  final bool has_reached_meeqaat;
  final bool has_done_after_meeqaat_tasks;
  final int tawaf_circle_count;
  final bool can_start_sai;
  final int sai_round_count;
  final bool is_one_side_sai_run_completed;
  final Timestamp? created_at;
  final Timestamp? updated_at;
  HistoryModel({
    required this.uid,
    required this.user_id,
    required this.type,
    required this.is_doing,
    required this.has_done_before_meeqaat_tasks,
    required this.has_reached_meeqaat,
    required this.has_done_after_meeqaat_tasks,
    required this.tawaf_circle_count,
    required this.can_start_sai,
    required this.sai_round_count,
    required this.is_one_side_sai_run_completed,
    this.created_at,
    this.updated_at,
  });

  HistoryModel copyWith({
    String? uid,
    String? user_id,
    String? type,
    bool? is_doing,
    bool? has_done_before_meeqaat_tasks,
    bool? has_reached_meeqaat,
    bool? has_done_after_meeqaat_tasks,
    int? tawaf_circle_count,
    bool? can_start_sai,
    int? sai_round_count,
    bool? is_one_side_sai_run_completed,
    Timestamp? created_at,
    Timestamp? updated_at,
  }) {
    return HistoryModel(
      uid: uid ?? this.uid,
      user_id: user_id ?? this.user_id,
      type: type ?? this.type,
      is_doing: is_doing ?? this.is_doing,
      has_done_before_meeqaat_tasks: has_done_before_meeqaat_tasks ?? this.has_done_before_meeqaat_tasks,
      has_reached_meeqaat: has_reached_meeqaat ?? this.has_reached_meeqaat,
      has_done_after_meeqaat_tasks: has_done_after_meeqaat_tasks ?? this.has_done_after_meeqaat_tasks,
      tawaf_circle_count: tawaf_circle_count ?? this.tawaf_circle_count,
      can_start_sai: can_start_sai ?? this.can_start_sai,
      sai_round_count: sai_round_count ?? this.sai_round_count,
      is_one_side_sai_run_completed: is_one_side_sai_run_completed ?? this.is_one_side_sai_run_completed,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap({FieldValue? created_at, FieldValue? updated_at}) {
    return <String, dynamic>{
      'uid': uid,
      'user_id': user_id,
      'type': type,
      'is_doing': is_doing,
      'has_done_before_meeqaat_tasks': has_done_before_meeqaat_tasks,
      'has_reached_meeqaat': has_reached_meeqaat,
      'has_done_after_meeqaat_tasks': has_done_after_meeqaat_tasks,
      'tawaf_circle_count': tawaf_circle_count,
      'sai_round_count': sai_round_count,
      'can_start_sai': can_start_sai,
      'is_one_side_sai_run_completed': is_one_side_sai_run_completed,
      'created_at': created_at ?? this.created_at?.millisecondsSinceEpoch,
      'updated_at': updated_at ?? this.updated_at?.millisecondsSinceEpoch,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      uid: map['uid'],
      user_id: map['user_id'],
      type: map['type'],
      is_doing: map['is_doing'] ?? false,
      has_done_before_meeqaat_tasks: map['has_done_before_meeqaat_tasks'] ?? false,
      has_reached_meeqaat: map['has_reached_meeqaat'] ?? false,
      has_done_after_meeqaat_tasks: map['has_done_after_meeqaat_tasks'] ?? false,
      tawaf_circle_count: int.tryParse(map['tawaf_circle_count'].toString()) ?? 0,
      can_start_sai: map['can_start_sai'] ?? false,
      sai_round_count: int.tryParse(map['sai_round_count'].toString()) ?? 0,
      is_one_side_sai_run_completed: map['is_one_side_sai_run_completed'] ?? false,
      created_at: map['created_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['created_at']) : map['created_at'],
      updated_at: map['updated_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['updated_at']) : map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryModel.fromJson(String source) => HistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UmraModel(uid: $uid, user_id: $user_id, type: $type, is_doing: $is_doing, has_done_before_meeqaat_tasks: $has_done_before_meeqaat_tasks, has_reached_meeqaat: $has_reached_meeqaat, has_done_after_meeqaat_tasks: $has_done_after_meeqaat_tasks, tawaf_circle_count: $tawaf_circle_count, can_start_sai: $can_start_sai, sai_round_count: $sai_round_count, is_one_side_sai_run_completed: $is_one_side_sai_run_completed, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant HistoryModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.user_id == user_id &&
        other.type == type &&
        other.is_doing == is_doing &&
        other.has_done_before_meeqaat_tasks == has_done_before_meeqaat_tasks &&
        other.has_reached_meeqaat == has_reached_meeqaat &&
        other.has_done_after_meeqaat_tasks == has_done_after_meeqaat_tasks &&
        other.tawaf_circle_count == tawaf_circle_count &&
        other.can_start_sai == can_start_sai &&
        other.sai_round_count == sai_round_count &&
        other.is_one_side_sai_run_completed == is_one_side_sai_run_completed &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        user_id.hashCode ^
        type.hashCode ^
        is_doing.hashCode ^
        has_done_before_meeqaat_tasks.hashCode ^
        has_reached_meeqaat.hashCode ^
        has_done_after_meeqaat_tasks.hashCode ^
        tawaf_circle_count.hashCode ^
        can_start_sai.hashCode ^
        sai_round_count.hashCode ^
        is_one_side_sai_run_completed.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
