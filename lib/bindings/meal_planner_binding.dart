import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/viewmodels/meal_planner_viewmodel.dart';
import 'package:kulyx/features/meal_planner/viewmodels/meal_planner_ui_controller.dart';

class MealPlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MealPlannerViewModel>(() => MealPlannerViewModel());
    Get.lazyPut<MealPlannerUiController>(() => MealPlannerUiController());
  }
}
