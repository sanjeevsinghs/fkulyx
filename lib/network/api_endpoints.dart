class ApiEndpoints {
  // Base paths
  static const String base =
      'https://api.kuilyx.com/api/v1'; //main server linnk

  static const String login = '$base/auth/login';
  static const String trendingProducts = '$base/products/trending';
  static const String products = '$base/products';
  static const String categories = '$base/categories';
  static const String communityPosts = '$base/community/posts';
  static const String communityGroups = '$base/community/groups';
  static const String communityEvents = '$base/community/events';
  static const String followers = '$base/followers';
  static const String usersLimited = '$base/users/limited';
  static const String joinGroup = '$base/community/groups/join';

  // Wishlist endpoints
  static const String wishlistAdd = '$base/wishlist/add';
  static const String wishlistRemove = '$base/wishlist/remove';

  // Cart endpoints

  static const String cartAdd = '$base/cart/add';
  static const String cartCount = '$base/cart/count';
  static const String cartUser = '$base/cart/user';
  static const String cartDelete = '$base/cart';
  static const String cartItemRemove = '$base/cart/item';
  // static const String cartUpdate = '$base/cart/update';
  // static const String cartClear = '$base/cart/clear';
}
