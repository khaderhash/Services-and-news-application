class BeneficiaryModel {
  final int id;
  final String fullName;
  final String gender;
  final String birthDate;
  final String email;
  final String phoneNumber;
  final String residenceType;
  final String currentAddress;
  final String previousAddress;
  final String livingStatus;
  final String maritalStatus;
  final int familyMembers;
  final String education;
  final String job;
  final String weaknessesDisabilities;
  final String? notes;

  BeneficiaryModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    required this.residenceType,
    required this.currentAddress,
    required this.previousAddress,
    required this.livingStatus,
    required this.maritalStatus,
    required this.familyMembers,
    required this.education,
    required this.job,
    required this.weaknessesDisabilities,
    this.notes,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birth_date'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      residenceType: json['residence_type'] ?? '',
      currentAddress: json['current_address'] ?? '',
      previousAddress: json['previous_address'] ?? '',
      livingStatus: json['living_status'] ?? '',
      maritalStatus: json['marital_status'] ?? '',
      familyMembers: json['family_members'] ?? 0,
      education: json['education'] ?? '',
      job: json['job'] ?? '',
      weaknessesDisabilities: json['weaknesses_disabilities'] ?? '',
      notes: json['notes'],
    );
  }
}
