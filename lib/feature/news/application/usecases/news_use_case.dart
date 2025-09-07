import 'package:either_dart/either.dart';
import 'package:interview/feature/news/domain/failure/failures.dart';
import 'package:interview/core/usecase/usecase.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

import '../services/news_service.dart';

/// Use case for fetching all companies news
/// Follows Single Responsibility Principle (SRP)
class NewsUseCase extends UseCase<List<NewsEntity>, NoParams> {
  final NewsService _newsService;

  NewsUseCase({required NewsService newsService}) : _newsService = newsService;

  @override
  Future<Either<Failure, List<NewsEntity>>> call(NoParams params) async {
    return await _newsService.fetchYesterdayToNowNewsFromUs();
  }
}
