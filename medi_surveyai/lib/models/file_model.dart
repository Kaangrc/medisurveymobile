// file_model.dart
// dosya modeli
class FileModel {
  final String id;
  final String name;
  final String url;
  final String type;
  final int size;
  final DateTime createdAt;
  final String? description;
  final String? uploadedBy;
  final String? tenantId;

  FileModel({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.size,
    required this.createdAt,
    this.description,
    this.uploadedBy,
    this.tenantId,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      size: json['size'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      uploadedBy: json['uploadedBy'] as String?,
      tenantId: json['tenantId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'uploadedBy': uploadedBy,
      'tenantId': tenantId,
    };
  }
}
