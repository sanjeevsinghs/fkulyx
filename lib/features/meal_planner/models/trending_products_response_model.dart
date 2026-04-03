import 'product_model.dart';
import 'pagination_model.dart';

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
    try {
      return TrendingProductsResponse(
        success: json['success'] == true,
        data: TrendingProductsData.fromJson(
          (json['data'] ?? <String, dynamic>{}) as Map<String, dynamic>,
        ),
        message: (json['message'] ?? '').toString(),
        statusCode: ((json['statusCode'] ?? 0) as num).toInt(),
      );
    } catch (_) {
      return TrendingProductsResponse.empty();
    }
  }

  /// Factory for empty/default trending products response
  factory TrendingProductsResponse.empty() {
    return TrendingProductsResponse(
      success: true,
      data: TrendingProductsData.empty(),
      message: '',
      statusCode: 200,
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
    try {
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
    } catch (_) {
      return TrendingProductsData.empty();
    }
  }

  /// Factory for empty/default trending products data
  factory TrendingProductsData.empty() {
    return TrendingProductsData(products: [], pagination: Pagination.empty());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'products': products.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
