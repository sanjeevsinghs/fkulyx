import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/meal_planner_screen_model.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class MealPlannerUiController extends GetxController {
  final NetworkApiServices _networkApiServices = NetworkApiServices();

  final Rxn<MealPlannerScreenModel> screen = Rxn<MealPlannerScreenModel>();
  final RxList<TrendingProductModel> trendingProducts =
      <TrendingProductModel>[].obs;
  final RxString selectedFilterId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString trendingError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadScreenData();
  }

  Future<void> loadScreenData() async {
    isLoading.value = true;
    try {
      final List<MealCategoryModel> categories = await fetchCategories();

      final Map<String, dynamic> response = <String, dynamic>{
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

      final parsed = MealPlannerScreenModel.fromJson(response);
      screen.value = parsed;

      await fetchTrendingProducts();

      if (parsed.filters.isNotEmpty) {
        selectedFilterId.value = parsed.filters.first.id;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(String filterId) {
    selectedFilterId.value = filterId;
  }

  Future<List<MealCategoryModel>> fetchCategories() async {
    try {
      final response = await _networkApiServices.getApi(
        ApiEndpoints.categories,
      );
      if (response is! Map<String, dynamic>) {
        return _fallbackCategories();
      }

      final categoriesResponse = CategoriesResponse.fromJson(response);
      if (!categoriesResponse.success) {
        return _fallbackCategories();
      }

      return categoriesResponse.data.categories
          .map((e) => e.toMealCategoryModel())
          .toList();
    } catch (_) {
      return _fallbackCategories();
    }
  }

  List<MealCategoryModel> _fallbackCategories() {
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

  Future<void> fetchTrendingProducts() async {
    trendingError.value = '';

    try {
      final response = await _networkApiServices.getApi(
        ApiEndpoints.trendingProducts,
      );

      if (response is! Map<String, dynamic>) {
        trendingProducts.clear();
        trendingError.value = 'Invalid trending products response';
        return;
      }

      final trendingResponse = TrendingProductsResponse.fromJson(response);
      if (!trendingResponse.success) {
        trendingProducts.clear();
        trendingError.value = trendingResponse.message.isEmpty
            ? 'Failed to load trending products'
            : trendingResponse.message;
        return;
      }

      trendingProducts.value = trendingResponse.data.products;
    } catch (e) {
      trendingProducts.clear();
      trendingError.value = 'Failed to load trending products';
    }
  }

  List<MealCategoryModel> get visibleCategories {
    // Hook this to API filter mapping later if needed.
    return screen.value?.categories ?? const <MealCategoryModel>[];
  }
}
