import 'package:get/get.dart';
import 'package:kulyx/bindings/auth_binding.dart';
import 'package:kulyx/bindings/dashboard_binding.dart';
import 'package:kulyx/bindings/event_details_binding.dart';
import 'package:kulyx/bindings/lms_binding.dart';
import 'package:kulyx/bindings/marketplace_binding.dart';
import 'package:kulyx/bindings/meal_planner_binding.dart';
import 'package:kulyx/bindings/tab_bar_binding.dart';
import 'package:kulyx/routes/app_routes.dart';
import 'package:kulyx/routes/screens/tab_bar_shell.dart';
import 'package:kulyx/routes/screens/splash_view.dart';
import 'package:kulyx/features/auth/views/login_view.dart';
import 'package:kulyx/features/meal_planner/views/cart_view.dart';
import 'package:kulyx/features/meal_planner/views/product_details_view.dart';
import 'package:kulyx/features/meal_planner/viewmodels/cart_controller.dart';
import 'package:kulyx/features/meal_planner/viewmodels/product_details_controller.dart';
import 'package:kulyx/screens/community_forum/add_post_sceen.dart';
import 'package:kulyx/screens/community_forum/person_details_screen.dart';
import 'package:kulyx/screens/community_forum/event_detail_screen.dart';
import 'package:kulyx/screens/community_forum/post_details_screen.dart';
import 'package:kulyx/bindings/post_details_binding.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
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
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<CartController>()) {
          Get.lazyPut<CartController>(() => CartController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ProductDetailsController>()) {
          Get.lazyPut<ProductDetailsController>(
            () => ProductDetailsController(),
          );
        }
      }),
    ),
    GetPage(
      name: AppRoutes.eventDetailsScreen,
      page: () => const EventDetailScreen(),
      binding: EventDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.personDetailsScreen,
      page: () => const PersonDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.postDetailsScreen,
      page: () => const PostDetailsScreen(),
      binding: PostDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.addPostScreen,
      page: () => const AddPostScreen(),
    ),
  ];
}
