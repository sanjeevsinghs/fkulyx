import 'package:flutter/material.dart';

class TabRouteNames {
  static const String home = 'home';
  static const String marketplace = 'market_place';
  static const String lms = 'lms';
  static const String mealPlanner = 'meal_planner';
  static const String dashboard = 'dashboard';
}

class TabDestinationConfig {
  const TabDestinationConfig({
    required this.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String key;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class TabRoutes {
  static const List<TabDestinationConfig> destinations = <TabDestinationConfig>[
    TabDestinationConfig(
      key: TabRouteNames.home,
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    TabDestinationConfig(
      key: TabRouteNames.marketplace,
      label: 'Marketplace',
      icon: Icons.shopping_bag_outlined,
      selectedIcon: Icons.shopping_bag_rounded,
    ),
    TabDestinationConfig(
      key: TabRouteNames.lms,
      label: 'LMS',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book_rounded,
    ),
    TabDestinationConfig(
      key: TabRouteNames.mealPlanner,
      label: 'MealPlan',
      icon: Icons.food_bank_outlined,
      selectedIcon: Icons.food_bank_rounded,
    ),
    TabDestinationConfig(
      key: TabRouteNames.dashboard,
      label: 'Dashboard',
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
    ),
  ];
}
