abstract class IAppException implements Exception {
  final String? title;
  final String? description;
  final int? statusCode;

  const IAppException(
    this.title,
    this.description,
    this.statusCode,
  );
}

class AppException extends IAppException {
  AppException(
    super.title,
    super.description,
    super.statusCode,
  );

  @override
  String get title => super.title ?? "";

  @override
  String get description => super.description ?? "";

  @override
  int get statusCode => super.statusCode ?? 0;
}
