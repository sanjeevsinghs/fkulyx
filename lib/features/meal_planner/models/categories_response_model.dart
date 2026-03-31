import 'pagination_model.dart';
import 'category_item_model.dart';

class CategoriesResponse {
  CategoriesResponse({
    required this.success,
    required this.data,
    required this.message,
    required this.timestamp,
  });

  final bool success;
  final CategoriesData data;
  final String message;
  final DateTime? timestamp;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    try {
      return CategoriesResponse(
        success: json['success'] == true,
        data: CategoriesData.fromJson(
          (json['data'] ?? <String, dynamic>{}) as Map<String, dynamic>,
        ),
        message: (json['message'] ?? '').toString(),
        timestamp: json['timestamp'] == null
            ? null
            : DateTime.tryParse(json['timestamp'].toString()),
      );
    } catch (_) {
      return CategoriesResponse.empty();
    }
  }

  /// Factory for empty/default categories response
  factory CategoriesResponse.empty() {
    return CategoriesResponse(
      success: true,
      data: CategoriesData.empty(),
      message: '',
      timestamp: null,
    );
  }
}

class CategoriesData {
  CategoriesData({required this.categories, required this.pagination});

  final List<CategoryItem> categories;
  final Pagination pagination;

  factory CategoriesData.fromJson(Map<String, dynamic> json) {
    try {
      final rawCategories = (json['categories'] as List<dynamic>?) ?? <dynamic>[];
      return CategoriesData(
        categories: rawCategories
            .whereType<Map<String, dynamic>>()
            .map(CategoryItem.fromJson)
            .toList(),
        pagination: Pagination.fromJson(
          (json['pagination'] ?? <String, dynamic>{}) as Map<String, dynamic>,
        ),
      );
    } catch (_) {
      return CategoriesData.empty();
    }
  }

  /// Factory for empty/default categories data
  factory CategoriesData.empty() {
    return CategoriesData(
      categories: [],
      pagination: Pagination.empty(),
    );
  }
}
