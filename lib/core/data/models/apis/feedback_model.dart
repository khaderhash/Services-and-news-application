class FeedbackModel {
  final int rating;
  final bool isSatisfied;
  final bool willUseAgain;
  final String? notes;

  FeedbackModel({
    required this.rating,
    required this.isSatisfied,
    required this.willUseAgain,
    this.notes,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      rating: json['rating'] ?? 0,
      isSatisfied: json['is_satisfied'] ?? false,
      willUseAgain: json['will_use_again'] ?? false,
      notes: json['notes'],
    );
  }
}
