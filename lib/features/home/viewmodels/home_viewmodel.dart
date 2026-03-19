import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/meal_plan_model.dart';

class HomeViewModel extends GetxController {
  final RxList<MealPlan> mealPlans = RxList<MealPlan>([]);
  final RxBool isLoading = RxBool(false);
  final RxString error = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock meal plan data for home screen
      mealPlans.value = [
        MealPlan(id: '1', day: 'Monday', items: ['Breakfast', 'Lunch', 'Dinner']),
        MealPlan(id: '2', day: 'Tuesday', items: ['Lunch', 'Dinner']),
        MealPlan(id: '3', day: 'Wednesday', items: ['Breakfast', 'Snacks']),
        MealPlan(id: '4', day: 'Thursday', items: ['Breakfast', 'Lunch', 'Dinner']),
        MealPlan(id: '5', day: 'Friday', items: ['Lunch', 'Dinner']),
      ];
    } catch (e) {
      error.value = 'Failed to load data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHome() async {
    await fetchHomeData();
  }
}
