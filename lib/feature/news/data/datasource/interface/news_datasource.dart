import '../../../application/usecases/news_use_case.dart';
import '../../models/news_model.dart';

abstract class NewsDataSource {
  Future<List<NewsModel>> getNews(NewsParams params);
}
