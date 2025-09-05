import 'package:interview/core/model/response_model.dart';
import 'package:interview/core/repository/base_storage_repository.dart';
import 'package:interview/feature/news/data/models/news_model.dart';

import '../../application/params/news_params.dart';
import 'interface/news_datasource.dart';

class NewsLocalDataSourceIml extends BaseStorageRepository implements NewsDataSource {
  NewsLocalDataSourceIml(super.storage);

  @override
  Future<List<NewsModel>> getNews(NewsParams params) async {
    var request = await storage.read("news");

    final response = ResponseModel.fromJsonArray(
      request,
      bodyBuilder: (body) => body.map((item) => NewsModel.fromJson(item)).toList(),
    );

    return response.articles!;
  }
}
