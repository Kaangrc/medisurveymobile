// lib/models/question_model.dart
// soruların modeli
class QuestionModel {
  final String question;
  final String type;
  final int level;
  final List<String>? options;

  QuestionModel({
    required this.question,
    required this.type,
    required this.level,
    this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'],
      type: json['type'],
      level: json['level'],
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'question': question,
      'type': type,
      'level': level,
    };

    if (options != null) {
      map['options'] = options!.toList();
    }

    return map;
  }
}
