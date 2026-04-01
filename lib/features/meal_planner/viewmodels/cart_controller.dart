import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/index.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class CartController extends GetxController {
  // ========== Cart State ==========
  final cartItems = <CartItem>[].obs;
  final isLoading = false.obs;
  final cartError = ''.obs;

  // ========== Computed Getters ==========
  int get itemCount => cartItems.length;

  int get totalQuantity =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => cartItems.isEmpty;

  bool get hasItems => cartItems.isNotEmpty;

  // ========== Public Methods ==========

  /// Add product to cart
  void addToCart({
    required String productId,
    required String productName,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) {
    try {
      final existingIndex = cartItems.indexWhere(
        (item) => item.productId == productId,
      );

      if (existingIndex != -1) {
        // ✅ Product already in cart - increase quantity
        final existingItem = cartItems[existingIndex];
        cartItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
      } else {
        // ✅ New product - add to cart
        final newItem = CartItem(
          productId: productId,
          productName: productName,
          price: price,
          imageUrl: imageUrl,
          quantity: quantity,
          addedAt: DateTime.now(),
        );
        cartItems.add(newItem);
      }
      Get.snackbar('Success', '$productName added to cart');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to cart');
    }
  }

  /// Remove product from cart
  Future<void> removeFromCart(String productId, {String itemId = ''}) async {
    try {
      final removedItem = cartItems.firstWhere(
        (item) => item.productId == productId,
      );

      final idToUse = itemId.isNotEmpty ? itemId : removedItem.itemId;

      if (idToUse.isEmpty) {
        Get.snackbar('Error', 'Cannot remove item: missing item ID');
        return;
      }

      final response = await NetworkApiServices().deleteApi(
        '${ApiEndpoints.cartItemRemove}/$idToUse',
      );

      if (response is Map<String, dynamic> && response['success'] == true) {
        cartItems.removeWhere((item) => item.productId == productId);
        Get.snackbar('Removed', '${removedItem.productName} removed from cart');
        return;
      }

      final message = response is Map<String, dynamic>
          ? (response['message'] ?? 'Failed to remove item from cart')
          : 'Failed to remove item from cart';
      Get.snackbar('Error', message);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Update quantity
  void updateQuantity(String productId, int newQuantity) {
    try {
      if (newQuantity <= 0) {
        removeFromCart(productId);
        return;
      }

      final index = cartItems.indexWhere((item) => item.productId == productId);
      if (index != -1) {
        cartItems[index] = cartItems[index].copyWith(quantity: newQuantity);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity');
    }
  }

  /// Clear entire cart
  void clearCart() {
    try {
      cartItems.clear();
      Get.snackbar('Success', 'Cart cleared');
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear cart');
    }
  }

  /// Checkout (API call would go here)
  Future<void> checkout() async {
    try {
      if (cartItems.isEmpty) {
        Get.snackbar('Error', 'Cart is empty');
        return;
      }

      isLoading.value = true;
      // TODO: Add API call to checkout endpoint
      // For now, just clear cart on success
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar('Success', 'Order placed successfully');
      clearCart();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void setCartItemsFromUserApi(Map<String, dynamic> response) {
    try {
      final data = response['data'];
      final cart = data is Map<String, dynamic> ? data['cart'] : null;
      final itemsRaw = cart is Map<String, dynamic> ? cart['items'] : null;

      if (itemsRaw is! List) {
        cartItems.clear();
        cartError.value = '';
        return;
      }

      final items = <CartItem>[];
      for (final raw in itemsRaw) {
        if (raw is! Map<String, dynamic>) continue;

        final itemId = _asString(raw['_id']);
        final product = raw['product'];
        final selectedVariant = raw['selectedVariant'];

        final productId = _asString(
          product is Map<String, dynamic> ? product['id'] : null,
          fallback: _asString(raw['variantId']),
        );

        final productName = _asString(
          product is Map<String, dynamic> ? product['name'] : null,
          fallback: 'Product',
        );

        final price = _asDouble(
          selectedVariant is Map<String, dynamic>
              ? selectedVariant['price']
              : null,
        );

        final imageUrl = _asString(
          selectedVariant is Map<String, dynamic>
              ? (selectedVariant['primaryImage'] is Map<String, dynamic>
                    ? selectedVariant['primaryImage']['url']
                    : null)
              : null,
        );

        final quantity = _asInt(raw['quantity'], fallback: 1);

        final addedAtRaw = raw['updatedAt'] ?? raw['createdAt'];
        final addedAt =
            DateTime.tryParse(_asString(addedAtRaw)) ?? DateTime.now();

        items.add(
          CartItem(
            itemId: itemId,
            productId: productId,
            productName: productName,
            price: price,
            imageUrl: imageUrl,
            quantity: quantity,
            addedAt: addedAt,
          ),
        );
      }

      cartItems.assignAll(items);
      cartError.value = '';
    } catch (_) {
      cartError.value = 'Failed to map cart items';
      cartItems.clear();
    }
  }

  String _asString(dynamic value, {String fallback = ''}) {
    final text = value?.toString() ?? '';
    return text.isEmpty ? fallback : text;
  }

  int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double _asDouble(dynamic value, {double fallback = 0}) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
