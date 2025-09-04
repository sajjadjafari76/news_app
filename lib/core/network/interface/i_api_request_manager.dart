import 'package:dio/dio.dart';

abstract class IHttpClient {
  Dio getDio() {
    return Dio();
  }

  Future<dynamic> getRequest({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ResponseType responseType,
  });
}
