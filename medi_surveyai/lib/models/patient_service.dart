// patient_model.dart
class PatientModel{
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String dateOfBirth;
  final String gender;
  final String primaryPhone;
  final String secondaryPhone;
  final String fileIds;

  PatientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.primaryPhone,
    required this.secondaryPhone,
    required this.fileIds,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      primaryPhone: json['primaryPhone'],
      secondaryPhone: json['secondaryPhone'],
      fileIds: json['fileIds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'primaryPhone': primaryPhone,
      'secondaryPhone': secondaryPhone,
      'fileIds': fileIds,
    };
  }
}
