part of 'meal_planner_ui_controller.dart';

extension MealPlannerUiWishlistPart on MealPlannerUiController {
  Future<void> toggleWishlist(String productId) async {
    _syncUserIdFromToken();
    if (currentUserId.value.isEmpty) {
      AppSnackbar.show('User not found. Please login again.');
      return;
    }

    if (togglingWishlistIds.contains(productId)) {
      return;
    }

    final currentStatus = wishlistStatus[productId] ?? false;
    final nextStatus = !currentStatus;

    togglingWishlistIds.add(productId);
    _setWishlistState(productId, nextStatus);

    try {
      String message;
      if (nextStatus) {
        message = await _addWishlistItem(
          userId: currentUserId.value,
          productId: productId,
        );
      } else {
        message = await _removeWishlistItem(
          userId: currentUserId.value,
          productId: productId,
        );
      }

      AppSnackbar.show(message);
    } catch (e) {
      _setWishlistState(productId, currentStatus);
      AppSnackbar.show(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      togglingWishlistIds.remove(productId);
    }
  }

  bool isWishlisted(String productId) => wishlistStatus[productId] ?? false;

  bool isTogglingWishlist(String productId) =>
      togglingWishlistIds.contains(productId);

  void _setWishlistState(String productId, bool isWished) {
    wishlistStatus[productId] = isWished;

    final index = trendingProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final updatedProduct = trendingProducts[index].copyWith(
        isWished: isWished,
      );
      trendingProducts[index] = updatedProduct;
    }
  }

  Future<String> _addWishlistItem({
    required String userId,
    required String productId,
  }) async {
    final response = await _networkApiServices.postApi(<String, dynamic>{
      'userId': userId,
      'productId': productId,
    }, ApiEndpoints.wishlistAdd);

    if (response is Map<String, dynamic> && response['success'] == true) {
      return (response['message'] ?? 'Product added to wishlist successfully')
          .toString();
    }

    final message = response is Map<String, dynamic>
        ? (response['message'] ?? 'Failed to add product to wishlist')
              .toString()
        : 'Failed to add product to wishlist';
    throw Exception(message);
  }

  Future<String> _removeWishlistItem({
    required String userId,
    required String productId,
  }) async {
    final url = '${ApiEndpoints.wishlistRemove}/$userId/$productId';
    final response = await _networkApiServices.deleteApi(url);

    if (response is Map<String, dynamic> && response['success'] == true) {
      return (response['message'] ??
              'Product removed from wishlist successfully')
          .toString();
    }

    final message = response is Map<String, dynamic>
        ? (response['message'] ?? 'Failed to remove product from wishlist')
              .toString()
        : 'Failed to remove product from wishlist';
    throw Exception(message);
  }
}
