class NewsModel {
  final int id;
  final String shortDescription;
  final String? photoUrl;
  final String? fullDescription;
  final String? createdAt;

  NewsModel({
    required this.id,
    required this.shortDescription,
    this.photoUrl,
    this.fullDescription,
    this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      shortDescription: json['short_description'] ?? json['description'] ?? '',
      photoUrl: json['photo'],
      fullDescription: json['description'],
      createdAt: json['created_at'],
    );
  }
}
