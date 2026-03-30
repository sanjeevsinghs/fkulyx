import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/meal_plan_model.dart';

class MealPlannerViewModel extends GetxController {
  final RxList<MealPlan> mealPlans = RxList<MealPlan>([]);
  final RxBool isLoading = RxBool(false);
  final RxString error = RxString('');

}
