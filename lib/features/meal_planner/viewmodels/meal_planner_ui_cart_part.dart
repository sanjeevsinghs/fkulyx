part of 'meal_planner_ui_controller.dart';

extension MealPlannerUiCartPart on MealPlannerUiController {
  void syncUserIdFromToken() => _syncUserIdFromToken();

  bool isAddingToCart(String productId) => addingToCartIds.contains(productId);

  Future<void> onTrendingBagPressed(TrendingProductModel item) async {
    await addToCart(productId: item.id, variantId: item.variantId, quantity: 1);
  }

  Future<int> fetchCartCount() async {
    _syncUserIdFromToken();
    if (currentUserId.value.isEmpty) {
      throw Exception('User not found. Please login again.');
    }

    isCheckingCartCount.value = true;
    try {
      final response = await _networkApiServices.getApi(
        '${ApiEndpoints.cartCount}/${currentUserId.value}',
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid cart count response');
      }

      final success = response['success'] == true;
      if (!success) {
        throw Exception(
          (response['message'] ?? 'Failed to fetch cart count').toString(),
        );
      }

      final data = response['data'];
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid cart count data');
      }

      cartUniqueItems.value = _parseInt(data['uniqueItems']);
      cartTotalQuantity.value = _parseInt(data['totalQuantity']);

      return cartUniqueItems.value;
    } finally {
      isCheckingCartCount.value = false;
    }
  }

  Future<void> openCartByApiCount() async {
    try {
      final uniqueItems = await fetchCartCount();

      if (uniqueItems == 0) {
        Get.toNamed(
          AppRoutes.cart,
          arguments: <String, dynamic>{'apiUniqueItems': 0},
        );
        return;
      }

      await _fetchAndStoreUserCartItems();

      Get.toNamed(
        AppRoutes.cart,
        arguments: <String, dynamic>{'apiUniqueItems': uniqueItems},
      );
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> addToCart({
    required String productId,
    required String variantId,
    int quantity = 1,
  }) async {
    _syncUserIdFromToken();

    if (currentUserId.value.isEmpty) {
      Get.snackbar('Error', 'User not found. Please login again.');
      return;
    }

    if (productId.isEmpty || variantId.isEmpty) {
      Get.snackbar('Error', 'Product or variant is missing.');
      return;
    }

    if (addingToCartIds.contains(productId)) {
      return;
    }

    addingToCartIds.add(productId);

    try {
      final response = await _networkApiServices.postApi(<String, dynamic>{
        'userId': currentUserId.value,
        'productId': productId,
        'variantId': variantId,
        'opera': 'add',
        'quantity': quantity,
      }, ApiEndpoints.cartAdd);

      if (response is Map<String, dynamic> && response['success'] == true) {
        final message = (response['message'] ?? 'Product added to cart')
            .toString();
        Get.snackbar('Success', message);
        return;
      }

      final message = response is Map<String, dynamic>
          ? (response['message'] ?? 'Failed to add product to cart').toString()
          : 'Failed to add product to cart';
      Get.snackbar('Error', message);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      addingToCartIds.remove(productId);
    }
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  Future<void> _fetchAndStoreUserCartItems() async {
    final response = await _networkApiServices.getApi(
      '${ApiEndpoints.cartUser}/${currentUserId.value}',
    );

    if (response is! Map<String, dynamic>) {
      throw Exception('Invalid cart response');
    }

    if (response['success'] != true) {
      throw Exception(
        (response['message'] ?? 'Failed to fetch cart').toString(),
      );
    }

    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    cartController.setCartItemsFromUserApi(response);
  }
}
