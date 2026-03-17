import 'package:get/get.dart';
import 'package:kulyx/bindings/auth_binding.dart';
import 'package:kulyx/routes/app_routes.dart';
import 'package:kulyx/views/auth/login_view.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
  ];
}
