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
      const MealPlannerView(),
      const LmsView(),
      const MarketplaceView(),
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
        () => Container(
          color: Colors.black,
          child: SafeArea(
            // top: false,
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: BottomNavigationBar(
                backgroundColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex.value,
                onTap: controller.changeTabIndex,
                iconSize: 22,
                selectedItemColor: const Color(0xFFFF6A00),
                unselectedItemColor: Colors.white,
                selectedFontSize: 10,
                unselectedFontSize: 9,
                selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
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
          ),
        ),
      ),
    );
  }
}
