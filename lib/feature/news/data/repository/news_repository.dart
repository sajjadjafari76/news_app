import 'package:either_dart/either.dart';
import 'package:interview/core/errors/exception_mapper.dart';
import 'package:interview/core/errors/failures.dart';
import 'package:interview/core/errors/my_exception.dart';
import 'package:interview/feature/news/data/datasource/interface/news_datasource.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';
import 'package:interview/feature/news/domain/repository/news_repository.dart';

import '../../application/params/news_params.dart';

class HomeRepositoryImp extends NewsRepository {
  final NewsDataSource _newsDataSource;

  HomeRepositoryImp(this._newsDataSource);

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews(NewsParams params) async {
    try {
      var response = await _newsDataSource.getNews(params);
      return Right(response);
    } on AppException catch (e) {
      // Map data exceptions to domain failures
      print('Infrastructure Exception: ${e.description}');
      return Left(ExceptionMapper.mapExceptionToFailure(e));
    } catch (e) {
      // Handle unexpected errors
      print('Unexpected error: $e');
      return Left(ExceptionMapper.mapGenericExceptionToFailure(e));
    }
  }
}
