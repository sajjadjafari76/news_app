import 'package:either_dart/either.dart';
import 'package:interview/feature/news/domain/failure/failures.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

import '../../application/params/news_params.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getNews(NewsParams params);

  Future<Either<Failure, List<NewsEntity>>> getCachedNews(String company);

  Future<Either<Failure, void>> cacheNews(String company, List<NewsEntity> news);
}
