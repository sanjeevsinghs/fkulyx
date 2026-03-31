import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/viewmodels/index.dart';

class MealPlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealPlannerViewModel>(() => MealPlannerViewModel());
    Get.lazyPut<MealPlannerUiController>(() => MealPlannerUiController());
  }
}
