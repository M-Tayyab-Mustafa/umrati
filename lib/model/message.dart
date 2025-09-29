import '../export.dart';

class MessageModel {
  final String id;
  final String question;
  final String answer;
  final bool isLiked;
  final bool isGeneratingAnswer;
  MessageModel({required this.id, required this.question, required this.answer, required this.isLiked, required this.isGeneratingAnswer});

  MessageModel copyWith({String? id, String? question, String? answer, bool? isLiked, bool? isGeneratingAnswer}) {
    return MessageModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isLiked: isLiked ?? this.isLiked,
      isGeneratingAnswer: isGeneratingAnswer ?? this.isGeneratingAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'question': question, 'answer': answer, 'is_liked': isLiked};
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id']?.toString() ?? '',
      question: map['question']?.toString() ?? '',
      answer: map['answer']?.toString() ?? '',
      isLiked: map['is_liked'] ?? false,
      isGeneratingAnswer: false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(id: $id, question: $question, answer: $answer, is_liked: $isLiked, is_generating_answer: $isGeneratingAnswer)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.question == question && other.answer == answer && other.isLiked == isLiked && other.isGeneratingAnswer == isGeneratingAnswer;
  }

  @override
  int get hashCode {
    return id.hashCode ^ question.hashCode ^ answer.hashCode ^ isLiked.hashCode ^ isGeneratingAnswer.hashCode;
  }
}
