import 'package:either_dart/src/either.dart';
import 'package:interview/core/errors/failures.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

abstract class SomethingAlgorithm {
  List<NewsEntity> sortNews(List<List<NewsEntity>> data);
}
