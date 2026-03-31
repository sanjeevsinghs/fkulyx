import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kulyx/features/meal_planner/models/index.dart';
import 'package:kulyx/network/api_base_service.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class MealPlannerUiController extends GetxController {
  final NetworkApiServices _networkApiServices = NetworkApiServices();

  // ========== UI State ==========
  final screen = Rxn<MealPlannerScreenModel>();
  final trendingProducts = <TrendingProductModel>[].obs;
  final selectedFilterId = ''.obs;
  final isLoading = false.obs;
  final trendingError = ''.obs;
  final currentUserId = ''.obs;

  // ========== Wishlist State ==========
  final wishlistStatus =
      <String, bool>{}.obs; // Track wished status by productId
  final togglingWishlistIds = <String>{}.obs;
  final addingToCartIds = <String>{}.obs;

  // ========== Lifecycle ==========
  @override
  void onInit() {
    super.onInit();
    _initializeReactiveListeners();
    loadScreenData();
  }

  void _initializeReactiveListeners() {
    // Listen to filter changes and reload products
    ever(selectedFilterId, (_) {
      _fetchTrendingProducts();
    });
  }

  // ========== Public Methods ==========
  Future<void> loadScreenData() async {
    isLoading.value = true;
    try {
      final categories = await _fetchCategories();
      final screenData = _buildScreenData(categories);
      screen.value = MealPlannerScreenModel.fromJson(screenData);

      // Set default filter if not already selected
      final firstFilter = screen.value?.filters.firstOrNull;
      if (firstFilter != null && selectedFilterId.isEmpty) {
        selectedFilterId.value = firstFilter.id;
      }

      // Load trending products
      await _fetchTrendingProducts();
    } catch (e) {
      trendingError.value = 'Failed to load screen data';
      _showError('Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(String filterId) => selectedFilterId.value = filterId;

  Future<void> refreshData() => loadScreenData();

  void syncUserIdFromToken() => _syncUserIdFromToken();

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
      final response = await _networkApiServices.postApi({
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

  /// Toggle wishlist status for a product
  Future<void> toggleWishlist(String productId) async {
    _syncUserIdFromToken();
    if (currentUserId.value.isEmpty) {
      Get.snackbar('Error', 'User not found. Please login again.');
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

      Get.snackbar('Success', message);
    } catch (e) {
      _setWishlistState(productId, currentStatus);
      Get.snackbar('Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      togglingWishlistIds.remove(productId);
    }
  }

  void _setWishlistState(String productId, bool isWished) {
    wishlistStatus[productId] = isWished;

    // Update product in list
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
    final response = await _networkApiServices.postApi({
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

  /// Check if product is wishlisted
  bool isWishlisted(String productId) => wishlistStatus[productId] ?? false;

  bool isTogglingWishlist(String productId) =>
      togglingWishlistIds.contains(productId);

  // ========== Computed Getters ==========
  List<MealCategoryModel> get visibleCategories =>
      screen.value?.categories ?? [];

  bool get hasError => trendingError.isNotEmpty;

  bool get isEmpty => trendingProducts.isEmpty && !isLoading.value;

  // ========== Private Methods ==========
  Future<void> _fetchTrendingProducts() async {
    trendingError.value = '';
    try {
      final response = await _networkApiServices.getApi(
        ApiEndpoints.trendingProducts,
      );

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format');
      }

      final trendingResponse = TrendingProductsResponse.fromJson(response);
      if (!trendingResponse.success) {
        throw Exception(
          trendingResponse.message.isEmpty
              ? 'Failed to load products'
              : trendingResponse.message,
        );
      }

      trendingProducts.value = trendingResponse.data.products;

      // Initialize wishlist status from API response
      _initializeWishlistStatus();
    } catch (e) {
      trendingProducts.value = []; // Show empty list on error
      trendingError.value = 'Failed to load trending products';
      _showError('Failed to load products');
    }
  }

  Future<List<MealCategoryModel>> _fetchCategories() async {
    try {
      final response = await _networkApiServices.getApi(
        ApiEndpoints.categories,
      );

      if (response is! Map<String, dynamic>) {
        return _getDefaultCategories();
      }

      final categoriesResponse = CategoriesResponse.fromJson(response);
      return categoriesResponse.success
          ? categoriesResponse.data.categories
                .map((e) => e.toMealCategoryModel())
                .toList()
          : _getDefaultCategories();
    } catch (e) {
      return _getDefaultCategories();
    }
  }

  List<MealCategoryModel> _getDefaultCategories() {
    return [
      MealCategoryModel(
        id: 'c1',
        title: 'Groceries & Ingredients',
        imagePath: 'assets/images/meal_planer_shop_now.jpg',
      ),
      MealCategoryModel(
        id: 'c2',
        title: 'Kitchen Essentials',
        imagePath: 'assets/images/meal_planer_shop_now.jpg',
      ),
      MealCategoryModel(
        id: 'c3',
        title: 'Ready to Cook & Meal',
        imagePath: 'assets/images/meal_planer_shop_now.jpg',
      ),
      MealCategoryModel(
        id: 'c4',
        title: 'Cookware & Bakeware',
        imagePath: 'assets/images/meal_planer_shop_now.jpg',
      ),
    ];
  }

  Map<String, dynamic> _buildScreenData(List<MealCategoryModel> categories) {
    return {
      'searchPlaceholder': 'Search for anything',
      'hero': {
        'title': 'Discover Culinary Treasures from Around the World',
        'subtitle':
            'Shop unique handpicked ingredients from independent chefs, home cooks, and food artisans. Bring bold flavors to your kitchen and elevate your cooking.',
        'buttonText': 'Shop Now',
        'imagePath': 'assets/images/meal_planer_shop_now.jpg',
      },
      'categorySectionTitle': 'Shop by Categories',
      'filters': [
        {'id': 'all', 'label': 'All ', 'leadingEmoji': ''},
        {
          'id': 'groceries',
          'label': 'Groceries & Ingredients',
          'leadingEmoji': '🥗',
        },
        {'id': 'kitchen', 'label': 'Kitchen Essentials', 'leadingEmoji': '🍳'},
        {'id': 'cookware', 'label': 'Cookware', 'leadingEmoji': '🍽️'},
      ],
      'categories': categories
          .map((e) => {'id': e.id, 'title': e.title, 'imagePath': e.imagePath})
          .toList(),
    };
  }

  /// Initialize wishlist status from loaded products
  void _initializeWishlistStatus() {
    wishlistStatus.clear();
    for (var product in trendingProducts) {
      wishlistStatus[product.id] = product.isWished;
    }
  }

  void _syncUserIdFromToken() {
    if (currentUserId.value.isNotEmpty) return;

    final token = NetworkApiServices.accessToken.isNotEmpty
        ? NetworkApiServices.accessToken
        : ApiBaseService.accessToken;
    if (token.isEmpty) return;

    final parts = token.split('.');
    if (parts.length < 2) return;

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
      final userId = (payloadMap['sub'] ?? '').toString();
      if (userId.isNotEmpty) {
        currentUserId.value = userId;
      }
    } catch (_) {
      // Silent fallback when token is invalid.
    }
  }

  void _showError(String message) {
    Get.snackbar(
      '❌ Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 255, 100, 100),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 3),
    );
  }
}
