import 'package:get/get.dart';
import 'package:interview/feature/news/domain/failure/failures.dart';
import 'package:interview/core/usecase/usecase.dart';
import 'package:interview/feature/news/application/usecases/news_use_case.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

/// Controller for managing news display
/// Follows Single Responsibility Principle (SRP)
class NewsController extends GetxController {
  final NewsUseCase _newsUseCase;

  NewsController(this._newsUseCase);

  // Observable state
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var newsList = <NewsEntity>[].obs;
  var lastUpdated = DateTime.now().obs;

  /// Fetches news from all companies (Microsoft, Apple, Google, Tesla)
  /// Sorted by newest first, arranged sequentially by company
  Future<void> fetchAllNews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _newsUseCase.call(NoParams());

      result.fold((failure) => _handleFailure(failure), (news) {
        newsList.value = news;
        lastUpdated.value = DateTime.now();
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes the news list
  Future<void> refreshNews() async {
    await fetchAllNews();
  }

  /// Handles failure with user-friendly messages
  void _handleFailure(Failure failure) {
    errorMessage.value = failure.message;
    Get.snackbar(failure.title, failure.message);
  }

  /// Gets the company name from news title
  String getCompanyName(NewsEntity news) {
    final title = news.title?.toLowerCase() ?? '';
    if (title.contains('microsoft')) return 'Microsoft';
    if (title.contains('apple')) return 'Apple';
    if (title.contains('google')) return 'Google';
    if (title.contains('tesla')) return 'Tesla';
    return 'Unknown';
  }

  /// Formats date for display
  String formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllNews();
  }
}
