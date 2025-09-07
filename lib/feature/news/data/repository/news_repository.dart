import 'package:either_dart/either.dart';
import 'package:interview/core/errors/exception_mapper.dart';
import 'package:interview/feature/news/domain/failure/failures.dart';
import 'package:interview/core/errors/my_exception.dart';
import 'package:interview/feature/news/data/datasource/interface/news_local_datasource.dart';
import 'package:interview/feature/news/data/models/news_model.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';
import 'package:interview/feature/news/domain/repository/news_repository.dart';

import '../../application/params/news_params.dart';
import '../datasource/interface/news_remote_datasource.dart';

class HomeRepositoryImp extends NewsRepository {
  final NewsLocalDataSource _newsLocalDataSource;
  final NewsRemoteDataSource _newsRemoteDataSource;

  HomeRepositoryImp(this._newsLocalDataSource, this._newsRemoteDataSource);

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews(NewsParams params) async {
    try {
      List<NewsModel> news = await _newsRemoteDataSource.getNews(params);

      // Cache the fetched news
      await _newsLocalDataSource.cacheNews(news);

      List<NewsEntity> newsEntity = news.map((e) => e.toEntity()).toList();
      return Right(newsEntity);
    } catch (e) {
      // If remote fails, try to get cached data
      try {
        final cachedArticles = await _newsLocalDataSource.getCachedNews();
        if (cachedArticles.isNotEmpty) {
          return Right(cachedArticles.map((model) => model.toEntity()).toList());
        }
        return Left(ServerFailure(e.toString()));
      } catch (cacheError) {
        return Left(CacheFailure(cacheError.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getCachedNews() async {
    try {
      final news = await _newsLocalDataSource.getCachedNews();
      return Right(news.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheNews(List<NewsEntity> news) async {
    try {
      final models = news.map((entity) => NewsModel.fromEntity(entity)).toList();
      await _newsLocalDataSource.cacheNews(models);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
