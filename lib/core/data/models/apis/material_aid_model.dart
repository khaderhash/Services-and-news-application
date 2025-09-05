class MaterialAidModel {
  final int id;
  final String aidTypeDisplay;
  final String statusDisplay;
  final String aidType;
  final String status;
  final String? requestDate;
  final String? notes;

  MaterialAidModel({
    required this.id,
    required this.aidTypeDisplay,
    required this.statusDisplay,
    required this.aidType,
    required this.status,
    this.requestDate,
    this.notes,
  });

  factory MaterialAidModel.fromJson(Map<String, dynamic> json) {
    return MaterialAidModel(
      id: json['id'],
      aidTypeDisplay: json['aid_type_display'] ?? 'غير محدد',
      statusDisplay: json['status_display'] ?? 'غير محدد',
      aidType: json['aid_type'],
      status: json['status'],
      requestDate: json['request_date'],
      notes: json['notes'],
    );
  }
}
