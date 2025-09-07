import '../../../application/params/news_params.dart';
import '../../models/news_model.dart';

abstract class NewsLocalDataSource {
  Future<List<NewsModel>> getCachedNews();

  Future<void> cacheNews(List<NewsModel> news);

  Future<void> clearCache();
}
