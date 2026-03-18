import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/tabs/viewmodels/tab_viewmodel.dart';
import 'package:kulyx/features/home/views/home_view.dart';
import 'package:kulyx/features/marketplace/views/marketplace_view.dart';
import 'package:kulyx/features/lms/views/lms_view.dart';
import 'package:kulyx/features/meal_planner/views/meal_planner_view.dart';
import 'package:kulyx/features/dashboard/views/dashboard_view.dart';
import 'package:kulyx/routes/tab_routes.dart';

class TabBarShell extends StatelessWidget {
  const TabBarShell({super.key});

  @override
  Widget build(BuildContext context) {
    final TabViewModel controller = Get.find<TabViewModel>();

    final List<Widget> tabPages = [
      const HomeView(),
      const MarketplaceView(),
      const LmsView(),
      const MealPlannerView(),
      const DashboardView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: tabPages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTabIndex,
          selectedItemColor: const Color(0xFFFF6A00),
          unselectedItemColor: Colors.white,
          items: TabRoutes.destinations
              .map(
                (destination) => BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  label: destination.label,
                  activeIcon: Icon(destination.selectedIcon),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
