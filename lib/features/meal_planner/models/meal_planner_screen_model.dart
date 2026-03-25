class MealPlannerScreenModel {
  MealPlannerScreenModel({
    required this.searchPlaceholder,
    required this.hero,
    required this.categorySectionTitle,
    required this.filters,
    required this.categories,
  });

  final String searchPlaceholder;
  final MealHeroModel hero;
  final String categorySectionTitle;
  final List<MealFilterModel> filters;
  final List<MealCategoryModel> categories;

  factory MealPlannerScreenModel.fromJson(Map<String, dynamic> json) {
    return MealPlannerScreenModel(
      searchPlaceholder: (json['searchPlaceholder'] ?? 'Search for anything') as String,
      hero: MealHeroModel.fromJson((json['hero'] ?? <String, dynamic>{}) as Map<String, dynamic>),
      categorySectionTitle: (json['categorySectionTitle'] ?? 'Shop by Categories') as String,
      filters: ((json['filters'] ?? <dynamic>[]) as List<dynamic>)
          .map((e) => MealFilterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: ((json['categories'] ?? <dynamic>[]) as List<dynamic>)
          .map((e) => MealCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

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
    return MealHeroModel(
      title: (json['title'] ?? '') as String,
      subtitle: (json['subtitle'] ?? '') as String,
      buttonText: (json['buttonText'] ?? 'Shop Now') as String,
      imagePath: (json['imagePath'] ?? 'assets/images/meal_planer_shop_now.jpg') as String,
    );
  }
}

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
    return MealFilterModel(
      id: (json['id'] ?? '') as String,
      label: (json['label'] ?? '') as String,
      leadingEmoji: (json['leadingEmoji'] ?? '') as String,
    );
  }
}

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
    return MealCategoryModel(
      id: (json['id'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      imagePath: (json['imagePath'] ?? 'assets/images/splash.png') as String,
    );
  }
}
