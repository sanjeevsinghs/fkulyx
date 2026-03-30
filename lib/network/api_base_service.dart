import 'package:http/http.dart' as http;
import 'package:kulyx/network/api_endpoints.dart';

class ApiBaseService {
  static const String BASE_URL = ApiEndpoints.base;
  static String accessToken = '';

  Future<String> _getAuthToken() async {
    if (accessToken.isNotEmpty) {
      return accessToken;
    }
    return '';
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await _getAuthToken();
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get({
    required String path,
    bool tokenRequired = false,
  }) async {
    final headers = await _getHeaders(includeAuth: tokenRequired);
    final uri = Uri.parse(path);
    return await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 30));
  }

  Future<http.Response> post({
    required String path,
    String? body,
    bool tokenRequired = false,
  }) async {
    final headers = await _getHeaders(includeAuth: tokenRequired);
    final uri = Uri.parse(path);
    return await http
        .post(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 30));
  }

  Future<http.Response> put({
    required String path,
    String? body,
    bool tokenRequired = false,
  }) async {
    final headers = await _getHeaders(includeAuth: tokenRequired);
    final uri = Uri.parse(path);
    return await http
        .put(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 30));
  }

  Future<http.Response> delete({
    required String path,
    String? body,
    bool tokenRequired = false,
  }) async {
    final headers = await _getHeaders(includeAuth: tokenRequired);
    final uri = Uri.parse(path);
    return await http
        .delete(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 30));
  }
}
