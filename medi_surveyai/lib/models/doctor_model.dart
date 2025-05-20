// doctor_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel extends UserModel {
  final String specialization;
  final String? hospital;
  final String? department;
  final List<String>? languages;
  final Map<String, dynamic>? schedule;

  DoctorModel({
    required super.id,
    required super.email,
    required super.name,
    required this.specialization,
    this.hospital,
    this.department,
    this.languages,
    this.schedule,
    required super.createdAt,
    required super.updatedAt,
  }) : super(role: UserRole.doctor);

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
