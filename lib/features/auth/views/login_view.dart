import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/features/auth/viewmodels/auth_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final AuthViewModel viewModel;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    viewModel = Get.find<AuthViewModel>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Image(
                    image: AssetImage('assets/images/culinary_tagline.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontFamily: "forum",
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  'Login to access your Culinary account.',
                  style: TextStyle(
                    fontFamily: "roboto",
                    fontSize: 15,
                    color: Color(0xFF313131),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Email',
                style: TextStyle(
                  fontFamily: "roboto",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1C1B1F),
                ),
              ),
              const SizedBox(height: 2),
              TextField(
                controller: emailController,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'john.doe@gmail.com',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFD6D6D6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: passwordController,
                  enableInteractiveSelection: false,
                  obscureText: viewModel.isPasswordHidden.value,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFD6D6D6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      onPressed: viewModel.togglePasswordVisibility,
                      icon: Icon(
                        viewModel.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: viewModel.rememberMe.value,
                      onChanged: (_) => viewModel.toggleRememberMe(),
                    ),
                  ),
                  const Text('Remember me'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(color: Color(0xFFFF6A00)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading.value
                        ? null
                        : () => viewModel.login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6A00),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xFFFF6A00),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
