import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/meal_planner/viewmodels/meal_planner_viewmodel.dart';

class MealPlannerView extends StatelessWidget {
  const MealPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final MealPlannerViewModel viewModel = Get.find<MealPlannerViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Meal Planner',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Plan your weekly meals and track diet goals.',
              style: TextStyle(color: Color(0xFF666666)),
            ),
            const SizedBox(height: 14),
            Obx(
              () => viewModel.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error.value.isNotEmpty
                      ? Center(child: Text(viewModel.error.value))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: viewModel.mealPlans.length,
                            itemBuilder: (context, index) {
                              final plan = viewModel.mealPlans[index];
                              return _DayPlanCard(
                                day: plan.day,
                                items: plan.items.join(', '),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayPlanCard extends StatelessWidget {
  const _DayPlanCard({required this.day, required this.items});

  final String day;
  final String items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_today, color: Color(0xFFFF6A00), size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(day, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(items, style: const TextStyle(color: Color(0xFF666666))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF999999)),
        ],
      ),
    );
  }
}
