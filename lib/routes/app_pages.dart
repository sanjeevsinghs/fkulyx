import 'package:get/get.dart';
import 'package:kulyx/bindings/auth_binding.dart';
import 'package:kulyx/bindings/dashboard_binding.dart';
import 'package:kulyx/bindings/lms_binding.dart';
import 'package:kulyx/bindings/marketplace_binding.dart';
import 'package:kulyx/bindings/meal_planner_binding.dart';
import 'package:kulyx/bindings/tab_bar_binding.dart';
import 'package:kulyx/routes/app_routes.dart';
import 'package:kulyx/routes/screens/tab_bar_shell.dart';
import 'package:kulyx/features/auth/views/login_view.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const TabBarShell(),
      bindings: [
        AuthBinding(),
        TabBinding(),
        // HomeBinding(),
        MarketplaceBinding(),
        LmsBinding(),
        MealPlannerBinding(),
        DashboardBinding(),
      ],
    ),
  ];
}
