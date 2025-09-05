import 'package:either_dart/either.dart';
import 'package:interview/core/errors/failures.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

import '../../application/params/news_params.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getNews(NewsParams params);
}
