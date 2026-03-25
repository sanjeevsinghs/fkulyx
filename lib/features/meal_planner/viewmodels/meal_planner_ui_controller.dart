import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/meal_planner_screen_model.dart';

class MealPlannerUiController extends GetxController {
  final Rxn<MealPlannerScreenModel> screen = Rxn<MealPlannerScreenModel>();
  final RxString selectedFilterId = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadScreenData();
  }

  Future<void> loadScreenData() async {
    isLoading.value = true;
    try {
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
          <String, dynamic>{'id': 'groceries', 'label': 'Groceries & Ingredients', 'leadingEmoji': '🥗'},
          <String, dynamic>{'id': 'kitchen', 'label': 'Kitchen Essentials', 'leadingEmoji': '🍳'},
          <String, dynamic>{'id': 'cookware', 'label': 'Cookware', 'leadingEmoji': '🍽️'},
        ],
        'categories': <Map<String, dynamic>>[
          <String, dynamic>{'id': 'c1', 'title': 'Groceries & Ingredients', 'imagePath': 'assets/images/meal_planer_shop_now.jpg'},
          <String, dynamic>{'id': 'c2', 'title': 'Kitchen Essentials', 'imagePath': 'assets/images/meal_planer_shop_now.jpg'},
          <String, dynamic>{'id': 'c3', 'title': 'Ready to Cook & Meal', 'imagePath': 'assets/images/meal_planer_shop_now.jpg'},
          <String, dynamic>{'id': 'c4', 'title': 'Cookware & Bakeware', 'imagePath': 'assets/images/meal_planer_shop_now.jpg'},
          <String, dynamic>{'id': 'c5', 'title': 'Small Kitchen Appliances', 'imagePath': 'assets/images/meal_planer_shop_now.jpg'},
          <String, dynamic>{'id': 'c6', 'title': 'Knives & Cutting Tools', 'imagePath': 'assets/images/meal_planer_shop_now.jpg'},
           <String, dynamic>{'id': 'c7', 'title': 'Small Kitchen Appliances', 'imagePath': 'assets/images/meal_planer_shop_now.jpg'},
          <String, dynamic>{'id': 'c8', 'title': 'Knives & Cutting Tools', 'imagePath': 'assets/images/meal_planer_shop_now.jpg'},
        ],
      };

      final parsed = MealPlannerScreenModel.fromJson(response);
      screen.value = parsed;

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

  List<MealCategoryModel> get visibleCategories {
    // Hook this to API filter mapping later if needed.
    return screen.value?.categories ?? const <MealCategoryModel>[];
  }
}
