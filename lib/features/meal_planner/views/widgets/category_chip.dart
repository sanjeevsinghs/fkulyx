import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/models/meal_planner_screen_model.dart';
import 'package:kulyx/features/meal_planner/viewmodels/meal_planner_ui_controller.dart';

class CategoryChip extends GetView<MealPlannerUiController> {
  const CategoryChip({super.key, required this.filter});

  final MealFilterModel filter;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedFilterId.value == filter.id;

      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: Material(
          color: isSelected ? const Color(0xFFFF6A00) : const Color(0xFFFDF2EE),
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => controller.selectFilter(filter.id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF6A00)
                      : const Color(0xFFE0E0E0),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (filter.leadingEmoji.isNotEmpty) ...[
                    Text(filter.leadingEmoji, style: const TextStyle(fontSize: 29),textAlign: TextAlign.center,),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : const Color(0xFF666666),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
