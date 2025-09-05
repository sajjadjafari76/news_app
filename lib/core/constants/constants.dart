import 'package:dio/dio.dart';

class Constants {
  static const String baseUrl = "https://newsapi.org/v2";
  static const String baseUrlImage = "";

  static Duration duration = const Duration(minutes: 1);
  static ResponseType responseJsonType = ResponseType.json;
}
