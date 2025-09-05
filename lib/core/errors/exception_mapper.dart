import 'failures.dart';
import 'my_exception.dart';

/// Maps infrastructure exceptions to domain failures
class ExceptionMapper {
  const ExceptionMapper._();

  /// Maps AppException to appropriate domain Failure
  static Failure mapExceptionToFailure(AppException exception) {
    switch (exception.runtimeType) {
      case BadRequestException:
        return ValidationFailure(exception.description);

      case UnauthorizedException:
        return AuthenticationFailure(exception.description);

      case ForbiddenException:
        return AuthorizationFailure(exception.description);

      case NotFoundException:
        return NotFoundFailure(exception.description);

      case InternalServerErrorException:
        return ServerFailure(exception.description);

      case ServiceUnavailableException:
        return ServiceUnavailableFailure(exception.description);

      case NetworkException:
        return NetworkFailure(exception.description);

      case TimeoutException:
        return TimeoutFailure(exception.description);

      case TooManyRequestsException:
        return RateLimitFailure(exception.description);

      case BadGatewayException:
      case GatewayTimeoutException:
        return ServerFailure(exception.description);

      case ConflictException:
      case UnprocessableEntityException:
        return ValidationFailure(exception.description);

      case MethodNotAllowedException:
        return ServerFailure(exception.description);

      default:
        return UnknownFailure(exception.description);
    }
  }

  /// Maps generic exceptions to domain failures
  static Failure mapGenericExceptionToFailure(dynamic exception) {
    if (exception is AppException) {
      return mapExceptionToFailure(exception);
    }

    // Handle other types of exceptions
    if (exception.toString().toLowerCase().contains('network')) {
      return const NetworkFailure();
    }

    if (exception.toString().toLowerCase().contains('timeout')) {
      return const TimeoutFailure();
    }

    return UnknownFailure(exception.toString());
  }
}
