import 'package:dio/dio.dart';

import '../constants/constants.dart';
import '../errors/error_helper.dart';
import 'interface/i_api_request_manager.dart';
import 'interceptors/dio_error_interceptor.dart';
import 'interceptors/dio_logger_interceptor.dart';

class DioHttpClient extends IHttpClient {
  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: Constants.duration,
      sendTimeout: Constants.duration,
      receiveTimeout: Constants.duration,
      responseType: Constants.responseJsonType,
      contentType: 'application/json',
    ),
  );

  @override
  Dio getDio() {
    return _dio;
  }

  DioHttpClient(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    dioInterceptorConfig();
  }

  void dioInterceptorConfig() {
    _dio.interceptors.addAll([
      DioErrorInterceptor(),
      DioLoggerInterceptor.curlDioLogger,
      DioLoggerInterceptor.prettyDioLogger,
    ]);
  }

  @override
  Future getRequest({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    ResponseType? responseType = ResponseType.plain,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers, responseType: responseType) : null,
      );
      return response.data;
    } on DioException catch (e) {
      throw ErrorHelper.getCatchError(e);
    }
  }
}
