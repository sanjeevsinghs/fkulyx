class Product {
  Product({
    required this.id,
    required this.variantId,
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
    this.isWished = false,
  });

  final String id;
  final String variantId;
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
  final bool isWished;

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
      variantId: (defaultVariant['_id'] ?? '').toString(),
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
      isWished: json['isWished'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'variantId': variantId,
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
      'isWished': isWished,
    };
  }

  /// Create a copy of this Product with optional field updates
  Product copyWith({
    String? id,
    String? variantId,
    String? name,
    double? averageRating,
    int? reviewCount,
    int? unitSoldCount,
    String? categoryName,
    String? imageUrl,
    double? price,
    double? mrp,
    bool? isOnSale,
    int? discountPercentage,
    bool? isWished,
  }) {
    return Product(
      id: id ?? this.id,
      variantId: variantId ?? this.variantId,
      name: name ?? this.name,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      unitSoldCount: unitSoldCount ?? this.unitSoldCount,
      categoryName: categoryName ?? this.categoryName,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      isOnSale: isOnSale ?? this.isOnSale,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      isWished: isWished ?? this.isWished,
    );
  }

  /// Empty/default product
  factory Product.empty() {
    return Product(
      id: '',
      variantId: '',
      name: '',
      averageRating: 0.0,
      reviewCount: 0,
      unitSoldCount: 0,
      categoryName: '',
      imageUrl: '',
      price: 0.0,
      mrp: 0.0,
      isOnSale: false,
      discountPercentage: null,
      isWished: false,
    );
  }
}

typedef TrendingProductModel = Product;
