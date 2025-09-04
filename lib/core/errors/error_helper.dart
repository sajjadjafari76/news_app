import 'package:dio/dio.dart';
import 'my_exception.dart';

class ErrorHelper {
  const ErrorHelper._();

  static AppException getCatchError(DioException error) {
    try {
      if (error.response != null) {
        if (error.response?.data != null) {
          return AppException(error.response?.data["message"], "", error.response?.statusCode);
        } else {
          return AppException(error.error.toString(), "", error.response?.statusCode);
        }
      } else {
        return AppException("Error", "error", error.response?.statusCode);
      }
    } catch (_) {
      return AppException("Error", "error", error.response?.statusCode);
    }
  }
}
