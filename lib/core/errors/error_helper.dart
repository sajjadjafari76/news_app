import 'package:dio/dio.dart';
import 'my_exception.dart';

class ErrorHelper {
  const ErrorHelper._();

  static AppException getCatchError(DioException error) {
    try {
      final statusCode = error.response?.statusCode;
      final message = _extractErrorMessage(error);

      // Handle different DioException types
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return TimeoutException(message);

        case DioExceptionType.connectionError:
          return NetworkException(message);

        case DioExceptionType.badResponse:
          return _getExceptionFromStatusCode(statusCode, message);

        case DioExceptionType.cancel:
          return AppException(
            "Request Cancelled",
            "The request was cancelled",
            statusCode,
          );

        case DioExceptionType.unknown:
        default:
          return NetworkException(message);
      }
    } catch (_) {
      return AppException(
        "Unknown Error",
        "An unexpected error occurred",
        error.response?.statusCode,
      );
    }
  }

  static String _extractErrorMessage(DioException error) {
    try {
      if (error.response?.data != null) {
        final data = error.response!.data;
        if (data is Map<String, dynamic>) {
          return data["message"] ?? data["error"] ?? data["detail"] ?? "";
        } else if (data is String) {
          return data;
        }
      }
      return error.message ?? "";
    } catch (_) {
      return error.message ?? "";
    }
  }

  static AppException _getExceptionFromStatusCode(
    int? statusCode,
    String message,
  ) {
    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 405:
        return MethodNotAllowedException(message);
      case 408:
        return TimeoutException(message);
      case 409:
        return ConflictException(message);
      case 422:
        return UnprocessableEntityException(message);
      case 429:
        return TooManyRequestsException(message);
      case 500:
        return InternalServerErrorException(message);
      case 502:
        return BadGatewayException(message);
      case 503:
        return ServiceUnavailableException(message);
      case 504:
        return GatewayTimeoutException(message);
      default:
        return AppException("HTTP Error", message, statusCode);
    }
  }
}
