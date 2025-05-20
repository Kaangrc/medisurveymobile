class FormAnswerModel {
  // cevaplanmış formların modeli
  final String id;
  final String formId;
  final List<FormAnswerField> answers;
  final DateTime createdAt;
  final String? tenantId;
  final String? answeredBy;
  final String? patientId;

  FormAnswerModel({
    required this.id,
    required this.formId,
    required this.answers,
    required this.createdAt,
    this.tenantId,
    this.answeredBy,
    this.patientId,
  });

  factory FormAnswerModel.fromJson(Map<String, dynamic> json) {
    return FormAnswerModel(
      id: json['id'] as String,
      formId: json['formId'] as String,
      answers: (json['answers'] as List)
          .map((answer) =>
              FormAnswerField.fromJson(answer as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      tenantId: json['tenantId'] as String?,
      answeredBy: json['answeredBy'] as String?,
      patientId: json['patientId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'tenantId': tenantId,
      'answeredBy': answeredBy,
      'patientId': patientId,
    };
  }
}

class FormAnswerField {
  final String fieldId;
  final String value;
  final DateTime? answeredAt;

  FormAnswerField({
    required this.fieldId,
    required this.value,
    this.answeredAt,
  });

  factory FormAnswerField.fromJson(Map<String, dynamic> json) {
    return FormAnswerField(
      fieldId: json['fieldId'] as String,
      value: json['value'] as String,
      answeredAt: json['answeredAt'] != null
          ? DateTime.parse(json['answeredAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldId': fieldId,
      'value': value,
      'answeredAt': answeredAt?.toIso8601String(),
    };
  }
}
