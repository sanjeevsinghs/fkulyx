// import 'user_model.dart';

// class LoginResponse {
//   final bool success;
//   final User user;
//   final String accessToken;
//   final String refreshToken;
//   final DateTime tokenExpiresAt;
//   final DateTime tokenCreatedAt;
//   final String message;
//   final DateTime timestamp;

//   LoginResponse({
//     required this.success,
//     required this.user,
//     required this.accessToken,
//     required this.refreshToken,
//     required this.tokenExpiresAt,
//     required this.tokenCreatedAt,
//     required this.message,
//     required this.timestamp,
//   });

//   // Convert JSON to LoginResponse
//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       success: json['success'] ?? false,
//       user: User.fromJson(json['data']['user']),
//       accessToken: json['data']['accessToken'] ?? '',
//       refreshToken: json['data']['refreshToken'] ?? '',
//       tokenExpiresAt: DateTime.parse(json['data']['tokenExpiresAt']),
//       tokenCreatedAt: DateTime.parse(json['data']['tokenCreatedAt']),
//       message: json['message'] ?? '',
//       timestamp: DateTime.parse(json['timestamp']),
//     );
//   }
// }