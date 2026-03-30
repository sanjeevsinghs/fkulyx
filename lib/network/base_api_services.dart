import 'dart:io';

abstract class BaseApiServices {
  Future<dynamic> getApi(String url);

  Future<dynamic> postApi(dynamic data, String url);

  Future<dynamic> postMultipartApi({
    required String url,
    required Map<String, String> fields,
    required File file,
    required String fileFieldName,
  });
}
