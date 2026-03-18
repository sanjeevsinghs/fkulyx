import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/dashboard/models/stat_model.dart';

class DashboardViewModel extends GetxController {
  final RxList<DashboardStat> stats = RxList<DashboardStat>([]);
  final RxBool isLoading = RxBool(false);
  final RxString error = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock data
      stats.value = [
        DashboardStat(title: 'Orders', value: '128', icon: Icons.shopping_bag_outlined),
        DashboardStat(title: 'Saved Recipes', value: '42', icon: Icons.bookmark_outline),
        DashboardStat(title: 'Learning Hours', value: '19h', icon: Icons.school_outlined),
        DashboardStat(title: 'Planned Meals', value: '24', icon: Icons.restaurant_menu_outlined),
      ];
    } catch (e) {
      error.value = 'Failed to load dashboard: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshDashboard() {
    fetchDashboardStats();
  }
}
