// lib/models/form_model.dart
//form şablonlarının modeli
import 'question_model.dart';

class FormModel {
  final String id;
  final String title;
  final String description;
  final List<FormField> fields;
  final DateTime createdAt;
  final String? tenantId;
  final String? createdBy;
  final bool isActive;

  FormModel({
    required this.id,
    required this.title,
    required this.description,
    required this.fields,
    required this.createdAt,
    this.tenantId,
    this.createdBy,
    this.isActive = true,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      fields: (json['fields'] as List)
          .map((field) => FormField.fromJson(field as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      tenantId: json['tenantId'] as String?,
      createdBy: json['createdBy'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'fields': fields.map((field) => field.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'tenantId': tenantId,
      'createdBy': createdBy,
      'isActive': isActive,
    };
  }
}

class FormField {
  final String id;
  final String type;
  final String label;
  final bool required;
  final List<String>? options;
  final String? defaultValue;
  final String? validation;

  FormField({
    required this.id,
    required this.type,
    required this.label,
    this.required = false,
    this.options,
    this.defaultValue,
    this.validation,
  });

  factory FormField.fromJson(Map<String, dynamic> json) {
    return FormField(
      id: json['id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List?)?.map((e) => e as String).toList(),
      defaultValue: json['defaultValue'] as String?,
      validation: json['validation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'required': required,
      'options': options,
      'defaultValue': defaultValue,
      'validation': validation,
    };
  }
}
