class ProjectRequestModel {
  final int id;
  final String projectType;
  final String ownership;
  final String area;
  final String experience;
  final String tools;
  final String? notes;
  final String status;
  final String createdAt;

  ProjectRequestModel({
    required this.id,
    required this.projectType,
    required this.ownership,
    required this.area,
    required this.experience,
    required this.tools,
    this.notes,
    required this.status,
    required this.createdAt,
  });

  factory ProjectRequestModel.fromJson(Map<String, dynamic> json) {
    return ProjectRequestModel(
      id: json['id'],
      projectType: json['project_type'] ?? 'N/A',
      ownership: json['ownership'] ?? 'N/A',
      area: json['area'] ?? 'N/A',
      experience: json['experience'] ?? 'N/A',
      tools: json['tools'] ?? 'N/A',
      notes: json['notes'],
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }

  String get statusDisplay {
    const statuses = {
      'pending': 'قيد المراجعة',
      'approved': 'موافق عليه',
      'delivered': 'تم التسليم',
    };
    return statuses[status] ?? status;
  }
}
