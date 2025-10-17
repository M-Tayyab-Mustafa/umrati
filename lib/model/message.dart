import '../export.dart';

class MessageModel {
  final String id;
  final String question;
  final String answer;
  final String gender;
  final bool gender_specific;
  final bool gender_required;
  final bool source_found;
  final bool send_to_mufti;
  final bool isLiked;
  final bool isGeneratingAnswer;
  final Timestamp? created_at;
  final Timestamp? updated_at;
  MessageModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.gender,
    required this.gender_specific,
    required this.gender_required,
    required this.source_found,
    required this.send_to_mufti,
    required this.isLiked,
    required this.isGeneratingAnswer,
    this.created_at,
    this.updated_at,
  });

  MessageModel copyWith({
    String? id,
    String? question,
    String? answer,
    String? gender,
    bool? gender_specific,
    bool? gender_required,
    bool? source_found,
    bool? send_to_mufti,
    bool? isLiked,
    bool? isGeneratingAnswer,
    Timestamp? created_at,
    Timestamp? updated_at,
  }) {
    return MessageModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      gender: gender ?? this.gender,
      gender_specific: gender_specific ?? this.gender_specific,
      gender_required: gender_required ?? this.gender_required,
      source_found: source_found ?? this.source_found,
      send_to_mufti: send_to_mufti ?? this.send_to_mufti,
      isLiked: isLiked ?? this.isLiked,
      isGeneratingAnswer: isGeneratingAnswer ?? this.isGeneratingAnswer,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toMap({FieldValue? created_at, FieldValue? updated_at}) {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'answer': answer,
      'gender': gender,
      'gender_specific': gender_specific,
      'gender_required': gender_required,
      'source_found': source_found,
      'send_to_mufti': send_to_mufti,
      'is_liked': isLiked,
      'created_at': created_at ?? this.created_at?.millisecondsSinceEpoch,
      'updated_at': updated_at ?? this.updated_at?.millisecondsSinceEpoch,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id']?.toString() ?? '',
      question: map['question']?.toString() ?? '',
      answer: map['answer']?.toString() ?? '',
      gender: map['gender']?.toString() ?? '',
      gender_specific: map['gender_specific'] ?? false,
      gender_required: map['gender_required'] ?? false,
      source_found: map['source_found'] ?? false,
      send_to_mufti: map['send_to_mufti'] ?? false,
      isLiked: map['is_liked'] ?? false,
      isGeneratingAnswer: false,
      created_at: map['created_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['created_at']) : map['created_at'],
      updated_at: map['updated_at'].runtimeType == int ? Timestamp.fromMillisecondsSinceEpoch(map['updated_at']) : map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(id: $id, question: $question, answer: $answer, gender: $gender, gender_specific: $gender_specific, gender_required: $gender_required, source_found: $source_found, send_to_mufti: $send_to_mufti, is_liked: $isLiked, is_generating_answer: $isGeneratingAnswer, created_at: $created_at, updated_at: $updated_at)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.question == question &&
        other.answer == answer &&
        other.gender == gender &&
        other.gender_specific == gender_specific &&
        other.gender_required == gender_required &&
        other.source_found == source_found &&
        other.send_to_mufti == send_to_mufti &&
        other.isLiked == isLiked &&
        other.isGeneratingAnswer == isGeneratingAnswer &&
        other.created_at == created_at &&
        other.updated_at == updated_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        answer.hashCode ^
        gender.hashCode ^
        gender_specific.hashCode ^
        gender_required.hashCode ^
        source_found.hashCode ^
        send_to_mufti.hashCode ^
        isLiked.hashCode ^
        isGeneratingAnswer.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode;
  }
}
