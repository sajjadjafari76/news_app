import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioLoggerInterceptor {
  static PrettyDioLogger get prettyDioLogger => PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    error: true,
    compact: true,
    maxWidth: 90,
  );

  static CurlLoggerDioInterceptor get curlDioLogger => CurlLoggerDioInterceptor();
}
