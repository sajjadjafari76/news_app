abstract class IAppException implements Exception {
  final String? title;
  final String? description;
  final int? statusCode;

  const IAppException(this.title, this.description, this.statusCode);
}

class AppException extends IAppException {
  AppException(super.title, super.description, super.statusCode);

  @override
  String get title => super.title ?? "";

  @override
  String get description => super.description ?? "";

  @override
  int get statusCode => super.statusCode ?? 0;
}

// Specific exception classes for different HTTP status codes
class BadRequestException extends AppException {
  BadRequestException([String? message])
    : super(
        "Bad Request",
        message ?? "The request was invalid or cannot be served",
        400,
      );
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
    : super(
        "Unauthorized",
        message ??
            "Authentication is required and has failed or has not been provided",
        401,
      );
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message])
    : super(
        "Forbidden",
        message ?? "The request was valid, but the server is refusing action",
        403,
      );
}

class NotFoundException extends AppException {
  NotFoundException([String? message])
    : super(
        "Not Found",
        message ?? "The requested resource could not be found",
        404,
      );
}

class MethodNotAllowedException extends AppException {
  MethodNotAllowedException([String? message])
    : super(
        "Method Not Allowed",
        message ?? "The method specified in the request is not allowed",
        405,
      );
}

class ConflictException extends AppException {
  ConflictException([String? message])
    : super(
        "Conflict",
        message ?? "The request could not be completed due to a conflict",
        409,
      );
}

class UnprocessableEntityException extends AppException {
  UnprocessableEntityException([String? message])
    : super(
        "Unprocessable Entity",
        message ?? "The request was well-formed but contained semantic errors",
        422,
      );
}

class TooManyRequestsException extends AppException {
  TooManyRequestsException([String? message])
    : super("Too Many Requests", message ?? "Rate limit exceeded", 429);
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message])
    : super(
        "Internal Server Error",
        message ?? "A generic error occurred on the server",
        500,
      );
}

class BadGatewayException extends AppException {
  BadGatewayException([String? message])
    : super(
        "Bad Gateway",
        message ??
            "The server received an invalid response from an upstream server",
        502,
      );
}

class ServiceUnavailableException extends AppException {
  ServiceUnavailableException([String? message])
    : super(
        "Service Unavailable",
        message ?? "The server is currently unavailable",
        503,
      );
}

class GatewayTimeoutException extends AppException {
  GatewayTimeoutException([String? message])
    : super(
        "Gateway Timeout",
        message ?? "The server did not receive a timely response",
        504,
      );
}

class NetworkException extends AppException {
  NetworkException([String? message])
    : super("Network Error", message ?? "Network connection failed", 0);
}

class TimeoutException extends AppException {
  TimeoutException([String? message])
    : super("Timeout", message ?? "Request timed out", 408);
}
