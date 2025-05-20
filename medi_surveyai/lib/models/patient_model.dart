class PatientModel {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String phone;
  final String? address;
  final DateTime? birthDate;
  final String? gender;
  final String? bloodType;
  final String? allergies;
  final String? chronicDiseases;
  final String? notes;

  PatientModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.phone,
    this.address,
    this.birthDate,
    this.gender,
    this.bloodType,
    this.allergies,
    this.chronicDiseases,
    this.notes,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String?,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : null,
      gender: json['gender'] as String?,
      bloodType: json['bloodType'] as String?,
      allergies: json['allergies'] as String?,
      chronicDiseases: json['chronicDiseases'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'phone': phone,
      'address': address,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'bloodType': bloodType,
      'allergies': allergies,
      'chronicDiseases': chronicDiseases,
      'notes': notes,
    };
  }
}
