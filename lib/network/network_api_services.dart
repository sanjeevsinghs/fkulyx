import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kulyx/network/app_exceptions.dart';
import 'package:kulyx/network/base_api_services.dart';
import 'package:kulyx/routes/app_routes.dart';

class NetworkApiServices extends BaseApiServices {
  static const Duration requestTimeout = Duration(seconds: 30);
  static String accessToken = '';

  Future<String> _getAuthToken() async {
    if (accessToken.isNotEmpty) {
      return accessToken;
    }

    return '';
  }

  Future<Map<String, String>> _getHeaders({
    bool includeAuth = true,
    bool isJson = true,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};

    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }

    if (includeAuth) {
      final token = await _getAuthToken();
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        if (kDebugMode) {
          print('Authorization header set with token: $token');
        }
      } else {
        if (kDebugMode) {
          print('WARNING: No auth token available for request');
        }
      }
    }

    return headers;
  }

  /// ----------- COMMON REQUEST HELPER (GET / POST / PUT / PATCH / DELETE) -----------
  Future<dynamic> _request(
    String method,
    String url, {
    dynamic data,
    bool includeAuth = true,
  }) async {
    if (kDebugMode) {
      print('$method $url');
      if (data != null) print(data);
    }

    dynamic responseJson;
    try {
      final startedAt = DateTime.now();
      final headers = await _getHeaders(includeAuth: includeAuth);
      final uri = Uri.parse(url);
      late http.Response response;
      if (kDebugMode) {
        print(headers);
      }
      switch (method) {
        case 'GET':
          response = await http
              .get(uri, headers: headers)
              .timeout(requestTimeout);
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: headers,
                body: data == null ? null : jsonEncode(data),
              )
              .timeout(requestTimeout);
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: headers,
                body: data == null ? null : jsonEncode(data),
              )
              .timeout(requestTimeout);
          break;
        case 'PATCH':
          response = await http
              .patch(
                uri,
                headers: headers,
                body: data == null ? null : jsonEncode(data),
              )
              .timeout(requestTimeout);
          break;
        case 'DELETE':
          response = await http
              .delete(
                uri,
                headers: headers,
                body: data == null ? null : jsonEncode(data),
              )
              .timeout(requestTimeout);
          break;
        default:
          throw FetchDataException('Unsupported HTTP method: $method');
      }
      if (response.statusCode == 401 && includeAuth) {
        accessToken = '';
        Get.offAllNamed(AppRoutes.login);
      }

      if (kDebugMode) {
        print(url);
        print(
          'Request duration: ${DateTime.now().difference(startedAt).inMilliseconds} ms',
        );
        print(
          "Response : ${response.body} and status code : ${response.statusCode}",
        );
      }

      responseJson = returnResponse(response);
    } on HandshakeException catch (e, st) {
      if (kDebugMode) {
        print('HandshakeException on $method $url: $e');
        print(st);
      }
      throw FetchDataException(
        'Secure connection failed. Please check your network date/time or try a different network.',
      );
    } on http.ClientException catch (e) {
      if (kDebugMode) {
        print('ClientException on $method $url: $e');
      }
      throw FetchDataException('Network client error: ${e.message}');
    } on SocketException catch (e, st) {
      if (kDebugMode) {
        print('SocketException on $method $url: $e');
        print(st);
      }
      throw InternetException('');
    } on TimeoutException catch (e, st) {
      if (kDebugMode) {
        print('TimeoutException on $method $url: $e');
        print(st);
      }
      throw RequestTimeOut('');
    } catch (e, st) {
      if (kDebugMode) {
        print('Unexpected exception on $method $url: $e');
        print(st);
      }
      throw FetchDataException('Unexpected network error: $e');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future<dynamic> getApi(String url) => _request('GET', url);

  @override
  Future<dynamic> postApi(dynamic data, String url) =>
      _request('POST', url, data: data);

  Future<dynamic> postApiWithoutAuth(dynamic data, String url) =>
      _request('POST', url, data: data, includeAuth: false);

  Future<dynamic> putApi(dynamic data, String url) =>
      _request('PUT', url, data: data);

  Future<dynamic> patchApi(dynamic data, String url) =>
      _request('PATCH', url, data: data);

  Future<dynamic> deleteApi(String url, {dynamic data}) =>
      _request('DELETE', url, data: data);

  @override
  Future<dynamic> postMultipartApi({
    required String url,
    required Map<String, String> fields,

    // supports both
    File? file,
    List<File>? mediaFiles,
    required String fileFieldName,
    String method = 'PUT',
  }) async {
    try {
      final headers = await _getHeaders(isJson: false);

      final request = http.MultipartRequest(
        method.toUpperCase(),
        Uri.parse(url),
      );

      request.headers.addAll(headers);
      request.fields.addAll(fields);

      // Normalize single & multiple files
      final List<File> uploadFiles = [];

      if (file != null) {
        uploadFiles.add(file);
      }

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        uploadFiles.addAll(mediaFiles);
      }

      for (final f in uploadFiles) {
        final multipartFile = await http.MultipartFile.fromPath(
          fileFieldName,
          f.path,
        );

        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );

      final response = await http.Response.fromStream(streamedResponse);

      return returnResponse(response);
    } on HandshakeException {
      throw FetchDataException(
        'Secure connection failed. Please check your network date/time or try a different network.',
      );
    } on http.ClientException catch (e) {
      throw FetchDataException('Network client error: ${e.message}');
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } catch (e) {
      throw FetchDataException('Unexpected network error: $e');
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);

      case 400:
      case 409:
        return jsonDecode(response.body);

      case 401:
        final responseJson = jsonDecode(response.body);
        if (isSessionExpired(responseJson)) {}
        return responseJson;

      case 404:
        throw FetchDataException('API Not Found');

      case 500:
        throw FetchDataException('Internal Server Error (500)');

      default:
        throw FetchDataException(
          'Error occurred while communicating with server. StatusCode: ${response.statusCode}',
        );
    }
  }

  bool isSessionExpired(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('isSessionExpired') &&
          response['isSessionExpired'] == true) {
        return true;
      }
    }
    return false;
  }

  Future postMultipartApiWithMultipleFiles({
    required String url,
    required Map<String, String> fields,
    required Map<String, File> files,
    required String method,
  }) async {
    try {
      final headers = await _getHeaders(isJson: false);
      var request = http.MultipartRequest(method.toUpperCase(), Uri.parse(url));
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      for (var entry in files.entries) {
        if (entry.value.existsSync()) {
          var multipartFile = await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      return returnResponse(response);
    } on HandshakeException {
      throw FetchDataException(
        'Secure connection failed. Please check your network date/time or try a different network.',
      );
    } on http.ClientException catch (e) {
      throw FetchDataException('Network client error: ${e.message}');
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } catch (e) {
      throw FetchDataException('Unexpected network error: $e');
    }
  }

  Future postMultipartApiWithFileEntries({
    required String url,
    required Map<String, String> fields,
    required List<MapEntry<String, File>> files,
    required String method,
  }) async {
    try {
      final headers = await _getHeaders(isJson: false);
      var request = http.MultipartRequest(method.toUpperCase(), Uri.parse(url));
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      for (var entry in files) {
        if (entry.value.existsSync()) {
          var multipartFile = await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      return returnResponse(response);
    } on HandshakeException {
      throw FetchDataException(
        'Secure connection failed. Please check your network date/time or try a different network.',
      );
    } on http.ClientException catch (e) {
      throw FetchDataException('Network client error: ${e.message}');
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } catch (e) {
      throw FetchDataException('Unexpected network error: $e');
    }
  }
}
