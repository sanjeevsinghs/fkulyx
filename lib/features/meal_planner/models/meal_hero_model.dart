class MealHeroModel {
  MealHeroModel({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final String imagePath;

  factory MealHeroModel.fromJson(Map<String, dynamic> json) {
    try {
      return MealHeroModel(
        title: (json['title'] ?? '') as String,
        subtitle: (json['subtitle'] ?? '') as String,
        buttonText: (json['buttonText'] ?? 'Shop Now') as String,
        imagePath:
            (json['imagePath'] ?? 'assets/images/meal_planer_shop_now.jpg')
                as String,
      );
    } catch (_) {
      return MealHeroModel.empty();
    }
  }

  /// Factory for empty/default meal hero model
  factory MealHeroModel.empty() {
    return MealHeroModel(
      title: '',
      subtitle: '',
      buttonText: '',
      imagePath: '',
    );
  }
}
