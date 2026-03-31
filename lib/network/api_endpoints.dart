class ApiEndpoints {
  // Base paths
  static const String base =
      'https://api.kuilyx.com/api/v1'; //main server linnk

  static const String login = '$base/auth/login';
  static const String trendingProducts = '$base/products/trending';
  static const String categories = '$base/categories';

  // Wishlist endpoints
  static const String wishlistAdd = '$base/wishlist/add';
  static const String wishlistRemove = '$base/wishlist/remove';
  static const String wishlistGet = '$base/wishlist';

  // Cart endpoints
  static const String cart = '$base/cart';
  static const String cartAdd = '$base/cart/add';
  static const String cartRemove = '$base/cart/remove';
  static const String cartUpdate = '$base/cart/update';
  static const String cartClear = '$base/cart/clear';
}
