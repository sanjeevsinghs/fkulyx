import 'meal_hero_model.dart';
import 'meal_filter_model.dart';
import 'meal_category_model.dart';

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
      searchPlaceholder:
          (json['searchPlaceholder'] ?? 'Search for anything') as String,
      hero: MealHeroModel.fromJson(
        (json['hero'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      categorySectionTitle:
          (json['categorySectionTitle'] ?? 'Shop by Categories') as String,
      filters: ((json['filters'] ?? <dynamic>[]) as List<dynamic>)
          .map((e) => MealFilterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: ((json['categories'] ?? <dynamic>[]) as List<dynamic>)
          .map((e) => MealCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Empty/default screen model
  factory MealPlannerScreenModel.empty() {
    return MealPlannerScreenModel(
      searchPlaceholder: 'Search for anything',
      hero: MealHeroModel.empty(),
      categorySectionTitle: 'Shop by Categories',
      filters: [],
      categories: [],
    );
  }
}
