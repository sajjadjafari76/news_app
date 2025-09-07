import '../../models/news_model.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsModel>> getCachedNews(String company);

  Future<void> cacheNews(String company, List<NewsModel> news);

  Future<void> clearCache(String company);
}
