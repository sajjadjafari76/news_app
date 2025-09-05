import 'package:either_dart/either.dart';
import 'package:interview/core/errors/failures.dart';
import 'package:interview/core/usecase/usecase.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

import '../../domain/repository/news_repository.dart';
import '../params/news_params.dart';
import '../services/sorting/interface/something_algorithm.dart';

class NewsUseCase extends UseCase<List<NewsEntity>, NewsParams> {
  final NewsRepository repository;
  final SomethingAlgorithm algorithm;

  NewsUseCase({required this.repository, required this.algorithm});

  @override
  Future<Either<Failure, List<NewsEntity>>> call(NewsParams params) async {
    final result = await repository.getNews(params);
    return result.fold((failure) => Left(failure), (news) => Right(algorithm.sortNews([news])));
  }
}
