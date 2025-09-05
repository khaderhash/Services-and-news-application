class ActivityModel {
  final int id;
  final String shortDescription;
  final String? photoUrl;
  final String? fullDescription;
  final String? createdAt;

  ActivityModel({
    required this.id,
    required this.shortDescription,
    this.photoUrl,
    this.fullDescription,
    this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      shortDescription: json['short_description'] ?? json['description'] ?? '',
      photoUrl: json['photo'],
      fullDescription: json['description'],
      createdAt: json['created_at'],
    );
  }
}
