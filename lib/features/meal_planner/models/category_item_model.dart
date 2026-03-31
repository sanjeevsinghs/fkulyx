import 'meal_category_model.dart';

class CategoryItem {
  CategoryItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String slug;
  final String imageUrl;

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    final image =
        (json['image'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return CategoryItem(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      imageUrl: (image['url'] ?? '').toString(),
    );
  }

  MealCategoryModel toMealCategoryModel() {
    return MealCategoryModel(id: id, title: name, imagePath: imageUrl);
  }

  /// Empty/default category item
  factory CategoryItem.empty() {
    return CategoryItem(id: '', name: '', slug: '', imageUrl: '');
  }
}
