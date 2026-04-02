import 'dart:convert';

import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/index.dart';
import 'package:kulyx/network/api_base_service.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';
import 'package:kulyx/routes/index.dart';
import 'package:kulyx/features/meal_planner/viewmodels/cart_controller.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

part 'meal_planner_ui_data_part.dart';
part 'meal_planner_ui_wishlist_part.dart';
part 'meal_planner_ui_cart_part.dart';

class MealPlannerUiController extends GetxController {
  final NetworkApiServices _networkApiServices = NetworkApiServices();

  // ========== UI State ==========
  final screen = Rxn<MealPlannerScreenModel>();
  final trendingProducts = <TrendingProductModel>[].obs;
  final selectedFilterId = ''.obs;
  final isLoading = false.obs;
  final trendingError = ''.obs;
  final currentUserId = ''.obs;
  final cartUniqueItems = 0.obs;
  final cartTotalQuantity = 0.obs;
  final isCheckingCartCount = false.obs;
  final isCartActionLoading = false.obs;

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
    AppSnackbar.show(message);
  }
}
