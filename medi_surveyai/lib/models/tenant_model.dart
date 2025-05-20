// tenant_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'tenant_model.g.dart';

@JsonSerializable()
class TenantModel extends UserModel {
  final String? address;
  final String? phoneNumber;
  final Map<String, dynamic>? preferences;
  final List<String>? medicalHistory;

  TenantModel({
    required super.id,
    required super.email,
    required super.name,
    this.address,
    this.phoneNumber,
    this.preferences,
    this.medicalHistory,
    required super.createdAt,
    required super.updatedAt,
  }) : super(role: UserRole.tenant);

  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenantModelToJson(this);
}
