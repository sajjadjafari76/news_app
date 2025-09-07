import 'package:get/get.dart';
import 'package:interview/feature/news/presentation/bindings/news_bindings.dart';
import 'package:interview/feature/news/presentation/bindings/news_detail_bindings.dart';
import 'package:interview/feature/news/presentation/page/news_detail_page.dart';
import 'package:interview/feature/news/presentation/page/news_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String newsList = "/";
  static const String newsDetail = "/detail";

  static final List<GetPage> pages = [
    GetPage(
      name: newsList,
      page: () => const NewsPage(),
      binding: NewsBindings(),
    ),
    GetPage(
      name: newsDetail,
      page: () => const NewsDetailPage(),
      binding: NewsDetailBindings(),
    ),
  ];
}
