class MealCategoryModel {
  MealCategoryModel({
    required this.id,
    required this.title,
    required this.imagePath,
  });

  final String id;
  final String title;
  final String imagePath;

  factory MealCategoryModel.fromJson(Map<String, dynamic> json) {
    try {
      return MealCategoryModel(
        id: (json['id'] ?? '') as String,
        title: (json['title'] ?? '') as String,
        imagePath: (json['imagePath'] ?? 'assets/images/splash.png') as String,
      );
    } catch (_) {
      return MealCategoryModel.empty();
    }
  }

  /// Factory for empty/default meal category model
  factory MealCategoryModel.empty() {
    return MealCategoryModel(
      id: '',
      title: '',
      imagePath: '',
    );
  }
}
