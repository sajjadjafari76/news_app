import 'package:hive/hive.dart';
import 'package:interview/core/model/response_model.dart';
import 'package:interview/core/repository/base_storage_repository.dart';
import 'package:interview/feature/news/data/models/news_model.dart';

import '../../application/params/news_params.dart';
import 'interface/news_local_datasource.dart';

class NewsLocalDataSourceIml extends BaseStorageRepository implements NewsLocalDataSource {
  NewsLocalDataSourceIml(super.storage);

  static const String _newsBoxName = 'news_list_cache_box';

  Box<NewsModel> get _newsBox => Hive.box<NewsModel>(_newsBoxName);

  @override
  Future<List<NewsModel>> getCachedNews() async {
    var result = _newsBox.values.toList();

    return result;
  }

  @override
  Future<void> cacheNews(List<NewsModel> articles) async {
    try {
      await _newsBox.clear();

      await _newsBox.addAll(articles);
    } catch (e) {
      throw Exception('Failed to cache news: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _newsBox.clear();
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }
}
