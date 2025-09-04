import 'package:dio/dio.dart';

class DioErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.receiveTimeout:
        return handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.message,
        ));
      case DioExceptionType.connectionTimeout:
        return handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.message,
        ));
      case DioExceptionType.sendTimeout:
        return handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.message,
        ));
      case DioExceptionType.unknown:
        return handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.message,
        ));
      case DioExceptionType.cancel:
        return handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.message,
        ));
      case DioExceptionType.badResponse:
        return handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.message,
        ));
      case DioExceptionType.badCertificate:
        return handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.message,
        ));
      case DioExceptionType.connectionError:
        return handler.next(DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: err.message,
        ));
    }
  }
}
