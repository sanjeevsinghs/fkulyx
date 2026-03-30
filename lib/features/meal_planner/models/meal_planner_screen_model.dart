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
      imagePath:
          (json['imagePath'] ?? 'assets/images/meal_planer_shop_now.jpg')
              as String,
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
  }
}

class CategoriesData {
  CategoriesData({required this.categories, required this.pagination});

  final List<CategoryItem> categories;
  final Pagination pagination;

  factory CategoriesData.fromJson(Map<String, dynamic> json) {
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
  }
}

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
}

class TrendingProductsResponse {
  TrendingProductsResponse({
    required this.success,
    required this.data,
    required this.message,
    required this.statusCode,
  });

  final bool success;
  final TrendingProductsData data;
  final String message;
  final int statusCode;

  factory TrendingProductsResponse.fromJson(Map<String, dynamic> json) {
    return TrendingProductsResponse(
      success: json['success'] == true,
      data: TrendingProductsData.fromJson(
        (json['data'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      message: (json['message'] ?? '').toString(),
      statusCode: ((json['statusCode'] ?? 0) as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'data': data.toJson(),
      'message': message,
      'statusCode': statusCode,
    };
  }
}

class TrendingProductsData {
  TrendingProductsData({required this.products, required this.pagination});

  final List<Product> products;
  final Pagination pagination;

  factory TrendingProductsData.fromJson(Map<String, dynamic> json) {
    final rawProducts = (json['products'] as List<dynamic>?) ?? <dynamic>[];
    return TrendingProductsData(
      products: rawProducts
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList(),
      pagination: Pagination.fromJson(
        (json['pagination'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'products': products.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Pagination {
  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: ((json['page'] ?? 1) as num).toInt(),
      limit: ((json['limit'] ?? 20) as num).toInt(),
      total: ((json['total'] ?? 0) as num).toInt(),
      totalPages: ((json['totalPages'] ?? 0) as num).toInt(),
      hasNext: json['hasNext'] == true,
      hasPrev: json['hasPrev'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrev': hasPrev,
    };
  }
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.averageRating,
    required this.reviewCount,
    required this.unitSoldCount,
    required this.categoryName,
    required this.imageUrl,
    required this.price,
    required this.mrp,
    required this.isOnSale,
    required this.discountPercentage,
  });

  final String id;
  final String name;
  final double averageRating;
  final int reviewCount;
  final int unitSoldCount;
  final String categoryName;
  final String imageUrl;
  final double price;
  final double mrp;
  final bool isOnSale;
  final int? discountPercentage;

  String? get badgeLabel {
    if (isOnSale && discountPercentage != null && discountPercentage! > 0) {
      return '$discountPercentage%';
    }
    return null;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final category =
        (json['category'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final defaultVariant =
        (json['defaultVariant'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    final primaryImage =
        (defaultVariant['primaryImage'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    final saleDetails =
        (defaultVariant['saleDetails'] as Map<String, dynamic>?) ??
        <String, dynamic>{};

    return Product(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      averageRating: ((json['averageRating'] ?? 0) as num).toDouble(),
      reviewCount: ((json['reviewCount'] ?? 0) as num).toInt(),
      unitSoldCount: ((json['unitSoldCount'] ?? 0) as num).toInt(),
      categoryName: (category['name'] ?? 'Trending').toString(),
      imageUrl: (primaryImage['url'] ?? '').toString(),
      price: ((defaultVariant['price'] ?? 0) as num).toDouble(),
      mrp: ((defaultVariant['mrp'] ?? 0) as num).toDouble(),
      isOnSale: defaultVariant['isOnSale'] == true,
      discountPercentage: saleDetails['discountPercentage'] == null
          ? null
          : (saleDetails['discountPercentage'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'unitSoldCount': unitSoldCount,
      'categoryName': categoryName,
      'imageUrl': imageUrl,
      'price': price,
      'mrp': mrp,
      'isOnSale': isOnSale,
      'discountPercentage': discountPercentage,
    };
  }
}

typedef TrendingProductModel = Product;
