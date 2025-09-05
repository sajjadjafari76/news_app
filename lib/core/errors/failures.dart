/// Base class for all domain failures
abstract class Failure {
  final String title;
  final String message;
  final String? code;

  const Failure(this.title, this.message, [this.code]);

  @override
  String toString() => 'Failure: $message';
}

/// General failures
class ServerFailure extends Failure {
  const ServerFailure([String? message])
    : super('Server Error', message ?? 'Server error occurred', 'Server error. Please try again later.');
}

class NetworkFailure extends Failure {
  const NetworkFailure([String? message])
    : super('Network Error', message ?? 'No internet connection. Please check your network.');
}

class CacheFailure extends Failure {
  const CacheFailure([String? message]) : super('Cache Error', message ?? 'Failed to load cached data.');
}

class ValidationFailure extends Failure {
  const ValidationFailure([String? message]) : super('Error', message ?? 'Invalid request. Please check your input.');
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String? message])
    : super('Authentication Required', message ?? 'Please log in to continue.');
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure([String? message])
    : super('Access Denied', message ?? 'You don\'t have permission to access this resource.');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String? message])
    : super('Not Found', message ?? 'The requested resource could not be found.');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([String? message]) : super('Timeout', message ?? 'Request timed out. Please try again.');
}

class RateLimitFailure extends Failure {
  const RateLimitFailure([String? message])
    : super('Rate Limited', message ?? 'Too many requests. Please wait a moment and try again.');
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure([String? message])
    : super('Service Unavailable', message ?? 'Service is temporarily unavailable. Please try again later.');
}

class UnknownFailure extends Failure {
  const UnknownFailure([String? message]) : super('Error', message ?? 'Something went wrong. Please try again.');
}
