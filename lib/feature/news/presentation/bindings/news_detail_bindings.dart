import 'package:get/get.dart';
import 'package:interview/feature/news/presentation/controller/news_detail_controller.dart';

class NewsDetailBindings extends Bindings {
  @override
  void dependencies() {
    // Controller
    Get.lazyPut<NewsDetailController>(() => NewsDetailController());
  }
}
