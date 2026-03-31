import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/index.dart';

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
      final existingIndex =
          cartItems.indexWhere((item) => item.productId == productId);

      if (existingIndex != -1) {
        // ✅ Product already in cart - increase quantity
        final existingItem = cartItems[existingIndex];
        cartItems[existingIndex] =
            existingItem.copyWith(quantity: existingItem.quantity + quantity);
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
  void removeFromCart(String productId) {
    try {
      final itemName = cartItems
          .firstWhere((item) => item.productId == productId)
          .productName;
      cartItems.removeWhere((item) => item.productId == productId);
      Get.snackbar('Success', '$itemName removed from cart');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from cart');
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
        cartItems[index] =
            cartItems[index].copyWith(quantity: newQuantity);
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
}
