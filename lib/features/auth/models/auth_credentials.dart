class AuthCredentials {
  final String email;
  final String password;
  final bool rememberMe;

  AuthCredentials({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  bool isValid() {
    return email.isNotEmpty && password.isNotEmpty;
  }

  bool isEmailValid() {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }
}
