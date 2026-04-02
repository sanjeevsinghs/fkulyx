part of 'meal_planner_ui_controller.dart';

extension MealPlannerUiDataPart on MealPlannerUiController {
  Future<void> loadScreenData() async {
    isLoading.value = true;
    try {
      final categories = await _fetchCategories();
      final screenData = _buildScreenData(categories);
      screen.value = MealPlannerScreenModel.fromJson(screenData);

      final firstFilter = screen.value?.filters.firstOrNull;
      if (firstFilter != null && selectedFilterId.isEmpty) {
        selectedFilterId.value = firstFilter.id;
      }

      await _fetchTrendingProducts();
      await loadCartCount();
    } catch (e) {
      trendingError.value = 'Failed to load screen data';
      _showError('Failed to load data');
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(String filterId) => selectedFilterId.value = filterId;

  Future<void> refreshData() => loadScreenData();

  List<MealCategoryModel> get visibleCategories =>
      screen.value?.categories ?? <MealCategoryModel>[];

  bool get hasError => trendingError.isNotEmpty;

  bool get isEmpty => trendingProducts.isEmpty && !isLoading.value;

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
      _initializeWishlistStatus();
    } catch (e) {
      trendingProducts.value = <TrendingProductModel>[];
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
    return <MealCategoryModel>[
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
    return <String, dynamic>{
      'searchPlaceholder': 'Search for anything',
      'hero': <String, dynamic>{
        'title': 'Discover Culinary Treasures from Around the World',
        'subtitle':
            'Shop unique handpicked ingredients from independent chefs, home cooks, and food artisans. Bring bold flavors to your kitchen and elevate your cooking.',
        'buttonText': 'Shop Now',
        'imagePath': 'assets/images/meal_planer_shop_now.jpg',
      },
      'categorySectionTitle': 'Shop by Categories',
      'filters': <Map<String, dynamic>>[
        <String, dynamic>{'id': 'all', 'label': 'All ', 'leadingEmoji': ''},
        <String, dynamic>{
          'id': 'groceries',
          'label': 'Groceries & Ingredients',
          'leadingEmoji': '🥗',
        },
        <String, dynamic>{
          'id': 'kitchen',
          'label': 'Kitchen Essentials',
          'leadingEmoji': '🍳',
        },
        <String, dynamic>{
          'id': 'cookware',
          'label': 'Cookware',
          'leadingEmoji': '🍽️',
        },
      ],
      'categories': categories
          .map(
            (e) => <String, dynamic>{
              'id': e.id,
              'title': e.title,
              'imagePath': e.imagePath,
            },
          )
          .toList(),
    };
  }

  void _initializeWishlistStatus() {
    wishlistStatus.clear();
    for (final product in trendingProducts) {
      wishlistStatus[product.id] = product.isWished;
    }
  }
}
