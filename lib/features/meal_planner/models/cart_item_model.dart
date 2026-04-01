class CartItem {
  CartItem({
    this.itemId = '',
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.addedAt,
  });

  final String itemId;
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  final int quantity;
  final DateTime addedAt;

  /// Get total price for this item
  double get totalPrice => price * quantity;

  /// Create a copy with optional updates
  CartItem copyWith({
    String? itemId,
    String? productId,
    String? productName,
    double? price,
    String? imageUrl,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      itemId: itemId ?? this.itemId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'itemId': itemId,
      'productId': productId,
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: (json['itemId'] ?? json['_id'] ?? '') as String,
      productId: (json['productId'] ?? '') as String,
      productName: (json['productName'] ?? '') as String,
      price: ((json['price'] ?? 0) as num).toDouble(),
      imageUrl: (json['imageUrl'] ?? '') as String,
      quantity: ((json['quantity'] ?? 1) as num).toInt(),
      addedAt: json['addedAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['addedAt'].toString()),
    );
  }

  /// Empty cart item for fallback
  factory CartItem.empty() {
    return CartItem(
      itemId: '',
      productId: '',
      productName: '',
      price: 0.0,
      imageUrl: '',
      quantity: 0,
      addedAt: DateTime.now(),
    );
  }
}
