import 'package:either_dart/either.dart';
import 'package:interview/core/errors/failures.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';
import 'package:interview/feature/news/domain/repository/news_repository.dart';

import '../params/news_params.dart';
import 'sorting/interface/something_algorithm.dart';

/// Service to orchestrate news fetching from multiple companies
/// Follows Single Responsibility Principle (SRP) and Dependency Inversion Principle (DIP)
class NewsService {
  final NewsRepository _repository;
  final SomethingAlgorithm _algorithm;

  static const _validCompanies = ['Microsoft', 'Apple', 'Google', 'Tesla'];

  const NewsService({
    required NewsRepository repository,
    required SomethingAlgorithm algorithm,
  }) : _repository = repository,
       _algorithm = algorithm;

  /// Fetches news from all valid companies and applies sorting
  Future<Either<Failure, List<NewsEntity>>> fetchAllCompaniesNews({
    required String country,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final allNews = <NewsEntity>[];

      // Fetch news from each company
      for (final company in _validCompanies) {
        final params = NewsParams.create(
          company: company,
          fromDate: fromDate,
          toDate: toDate,
          country: country,
        );

        final result = await _repository.getNews(params);

        result.fold((failure) {
          // Log error but continue with other companies
          // In production, you might want to use a proper logger
          print('Failed to fetch news for $company: ${failure.message}');
        }, (news) => allNews.addAll(news));
      }

      // Apply sorting algorithm
      final sortedNews = _algorithm.sortNews(allNews);

      return Right(sortedNews);
    } catch (e) {
      return Left(
        UnknownFailure('Failed to fetch news from all companies: $e'),
      );
    }
  }

  /// Fetches news from a specific company
  Future<Either<Failure, List<NewsEntity>>> fetchCompanyNews({
    required String company,
    required String country,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final params = NewsParams.create(
        company: company,
        fromDate: fromDate,
        toDate: toDate,
        country: country,
      );

      final result = await _repository.getNews(params);

      return result.fold(
        (failure) => Left(failure),
        (news) => Right(_algorithm.sortNews(news)),
      );
    } catch (e) {
      return Left(UnknownFailure('Failed to fetch news for $company: $e'));
    }
  }

  /// Fetches news from yesterday to now for all companies
  Future<Either<Failure, List<NewsEntity>>>
  fetchYesterdayToNowNewsFromUs() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return fetchAllCompaniesNews(
      fromDate: yesterday,
      toDate: now,
      country: "us",
    );
  }
}
