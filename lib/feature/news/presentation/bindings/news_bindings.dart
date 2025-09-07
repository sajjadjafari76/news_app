import 'package:get/get.dart';
import 'package:interview/core/constants/constants.dart';
import 'package:interview/core/network/dio_request_manager.dart';
import 'package:interview/core/network/interface/i_api_request_manager.dart';
import 'package:interview/feature/news/application/services/news_service.dart';
import 'package:interview/feature/news/application/services/sorting/interface/something_algorithm.dart';
import 'package:interview/feature/news/application/usecases/news_use_case.dart';
import 'package:interview/feature/news/data/datasource/interface/news_datasource.dart';
import 'package:interview/feature/news/data/datasource/news_api_datasource.dart';
import 'package:interview/feature/news/data/repository/news_repository.dart';
import 'package:interview/feature/news/domain/repository/news_repository.dart';
import 'package:interview/feature/news/presentation/controller/news_controller.dart';

/// Dependency injection setup following Dependency Inversion Principle (DIP)
class NewsBindings extends Bindings {
  @override
  void dependencies() {
    // IHttpClient
    Get.lazyPut<IHttpClient>(() => DioHttpClient(Constants.baseUrl));

    // Data layer
    Get.lazyPut<NewsDataSource>(() => NewsDataSourceIml(Get.find()));

    // Repository implementation
    Get.lazyPut<NewsRepository>(() => HomeRepositoryImp(Get.find<NewsDataSource>()));

    // Sorting algorithm
    Get.lazyPut<SomethingAlgorithm>(() => SequentialCompanyAlgorithm());

    // Service layer
    Get.lazyPut<NewsService>(
      () => NewsService(repository: Get.find<NewsRepository>(), algorithm: Get.find<SomethingAlgorithm>()),
    );

    // Use cases
    Get.lazyPut<NewsUseCase>(() => NewsUseCase(newsService: Get.find<NewsService>()));

    // Controller
    Get.lazyPut<NewsController>(() => NewsController(Get.find<NewsUseCase>()));
  }
}
