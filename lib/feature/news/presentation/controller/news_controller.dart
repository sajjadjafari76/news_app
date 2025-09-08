import 'package:get/get.dart';
import 'package:interview/feature/news/domain/failure/failures.dart';
import 'package:interview/core/usecase/usecase.dart';
import 'package:interview/feature/news/application/usecases/news_use_case.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

/// Controller for managing news display
class NewsController extends GetxController with StateMixin<List<NewsEntity>> {
  final NewsUseCase _newsUseCase;

  NewsController(this._newsUseCase);

  // Observable state
  // var isLoading = false.obs;
  // var errorMessage = ''.obs;
  var newsList = <NewsEntity>[].obs;
  var lastUpdated = DateTime.now().obs;

  /// Fetches news from all companies (Microsoft, Apple, Google, Tesla)
  /// Sorted by newest first, arranged sequentially by company
  Future<void> fetchAllNews() async {
    try {
      change(null, status: RxStatus.loading());

      final result = await _newsUseCase(NoParams());

      result.fold((failure) => _handleFailure(failure), (news) {
        newsList.value = news;
        lastUpdated.value = DateTime.now();
        change(newsList, status: RxStatus.success());
      });
    } finally {}
  }

  /// Refreshes the news list
  Future<void> refreshNews() async {
    await fetchAllNews();
  }

  /// Handles failure with user-friendly messages
  void _handleFailure(Failure failure) {
    change(null, status: RxStatus.error(failure.message));
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllNews();
  }
}
