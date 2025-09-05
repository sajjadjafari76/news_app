import '../../../application/params/news_params.dart';
import '../../models/news_model.dart';

abstract class NewsDataSource {
  Future<List<NewsModel>> getNews(NewsParams params);
}
