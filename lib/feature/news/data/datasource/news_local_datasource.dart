import 'package:hive/hive.dart';
import 'package:interview/core/repository/base_storage_repository.dart';
import 'package:interview/feature/news/data/models/news_model.dart';

import 'interface/news_local_datasource.dart';

class NewsLocalDataSourceIml extends BaseStorageRepository implements NewsLocalDataSource {
  NewsLocalDataSourceIml(super.storage);

  static const String _newsBoxName = 'news_list_cache_box';

  Box<List<NewsModel>> get _newsBox => Hive.box<List<NewsModel>>(_newsBoxName);

  @override
  Future<List<NewsModel>> getCachedNews(String company) async {
    var result = _newsBox.get(company) as List<NewsModel>;
    return result;
  }

  @override
  Future<void> cacheNews(String company, List<NewsModel> articles) async {
    try {
      await clearCache(company);

      await _newsBox.put(company, articles);
    } catch (e) {
      throw Exception('Failed to cache news: $e');
    }
  }

  @override
  Future<void> clearCache(String company) async {
    try {
      await _newsBox.delete(company);
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }
}
