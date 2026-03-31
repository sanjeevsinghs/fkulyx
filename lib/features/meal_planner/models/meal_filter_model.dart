class MealFilterModel {
  MealFilterModel({
    required this.id,
    required this.label,
    required this.leadingEmoji,
  });

  final String id;
  final String label;
  final String leadingEmoji;

  factory MealFilterModel.fromJson(Map<String, dynamic> json) {
    try {
      return MealFilterModel(
        id: (json['id'] ?? '') as String,
        label: (json['label'] ?? '') as String,
        leadingEmoji: (json['leadingEmoji'] ?? '') as String,
      );
    } catch (_) {
      return MealFilterModel.empty();
    }
  }

  /// Factory for empty/default meal filter model
  factory MealFilterModel.empty() {
    return MealFilterModel(
      id: '',
      label: '',
      leadingEmoji: '',
    );
  }
}
