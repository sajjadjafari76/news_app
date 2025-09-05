import 'package:interview/core/model/response_model.dart';
import 'package:interview/core/repository/base_api_repository.dart';
import 'package:interview/feature/news/data/models/news_model.dart';

import '../../application/params/news_params.dart';
import 'interface/news_datasource.dart';

class NewsDataSourceIml extends BaseRepository implements NewsDataSource {
  NewsDataSourceIml(super.httpClient);

  @override
  Future<List<NewsModel>> getNews(NewsParams params) async {
    final queryParameters = params.toMap();

    var request = await httpClient.getRequest(path: '/everything', queryParameters: queryParameters);

    final response = ResponseModel.fromJsonArray(
      request,
      bodyBuilder: (body) => body.map((item) => NewsModel.fromJson(item)).toList(),
    );

    return response.articles!;
  }
}
