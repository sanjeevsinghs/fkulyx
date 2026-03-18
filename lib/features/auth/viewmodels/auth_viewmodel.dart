import 'package:get/get.dart';
import 'package:kulyx/features/auth/models/auth_credentials.dart';
import 'package:kulyx/features/auth/models/user_model.dart';
import 'package:kulyx/routes/app_routes.dart';

class AuthViewModel extends GetxController {
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
        Get.snackbar('Error', 'Please fill all fields');
        return;
      }

      if (!credentials.isEmailValid()) {
        Get.snackbar('Error', 'Invalid email format');
        return;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create user
      final user = User(
        id: '1',
        name: email.split('@')[0],
        email: email,
      );

      currentUser.value = user;
      userName.value = user.name;
      userEmail.value = user.email;

      // Navigate to home
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      currentUser.value = null;
      userName.value = '';
      userEmail.value = '';
      rememberMe.value = false;

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
