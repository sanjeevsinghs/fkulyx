import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/auth/models/auth_credentials.dart';
import 'package:kulyx/features/auth/models/user_model.dart';
import 'package:kulyx/network/api_base_service.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';
import 'package:kulyx/routes/index.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class AuthViewModel extends GetxController {
  final NetworkApiServices _networkApiServices = NetworkApiServices();

  // State Variables
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = RxBool(false);
  final RxBool isPasswordHidden = RxBool(true);
  final RxBool rememberMe = RxBool(false);
  final RxString userName = RxString('');
  final RxString userEmail = RxString('');

  // Methods
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> login({required String email, required String password}) async {
    try {
      isLoading.value = true;

      // Validate credentials
      final credentials = AuthCredentials(
        email: email,
        password: password,
        rememberMe: rememberMe.value,
      );

      if (!credentials.isValid()) {
        AppSnackbar.show('Please fill all fields');
        return;
      }

      if (!credentials.isEmailValid()) {
        AppSnackbar.show('Invalid email format');
        return;
      }

      final response = await _networkApiServices.postApiWithoutAuth({
        'email': credentials.email,
        'password': credentials.password,
      }, ApiEndpoints.login);

      if (response is! Map<String, dynamic>) {
        AppSnackbar.show('Invalid server response');
        return;
      }

      final success = response['success'] == true;
      final message = (response['message'] ?? 'Login failed').toString();

      if (!success) {
        AppSnackbar.show(message);
        return;
      }

      final data = response['data'];
      if (data is! Map<String, dynamic>) {
        AppSnackbar.show('Missing login data');
        return;
      }

      final accessToken = (data['accessToken'] ?? '').toString();
      final refreshToken = (data['refreshToken'] ?? '').toString();

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        AppSnackbar.show('Missing token in response');
        return;
      }

      // Keep token in memory for authorized API calls.
      NetworkApiServices.accessToken = accessToken;
      ApiBaseService.accessToken = accessToken;

      final userJson = data['user'];
      if (userJson is! Map<String, dynamic>) {
        AppSnackbar.show('Missing user data');
        return;
      }

      final user = User(
        id: (userJson['_id'] ?? userJson['id'] ?? '').toString(),
        name: ((userJson['username'] ?? '') as String).trim().isNotEmpty
            ? (userJson['username'] as String)
            : '${(userJson['firstName'] ?? '').toString()} ${(userJson['lastName'] ?? '').toString()}'
                  .trim(),
        email: (userJson['email'] ?? email).toString(),
        avatar: userJson['profileImage']?.toString(),
      );

      currentUser.value = user;
      userName.value = user.name;
      userEmail.value = user.email;

      AppSnackbar.show(message);

      // Navigate to home
      Get.offAllNamed(AppRoutes.home);
    } catch (e, st) {
      if (kDebugMode) {
        print('Login exception: $e');
        print(st);
      }
      AppSnackbar.show('Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
