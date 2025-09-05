import 'package:interview/feature/news/domain/entities/news_entities.dart';

import 'interface/something_algorithm.dart';

class SequentialAlgorithm implements SomethingAlgorithm {
  @override
  List<NewsEntity> sortNews(List<List<NewsEntity>> data) {
    return roundRobinMerge(data);
  }

  List<NewsEntity> roundRobinMerge(List<List<NewsEntity>> buckets) {
    final result = <NewsEntity>[];
    var index = 0;

    while (true) {
      var added = false;
      for (final list in buckets) {
        if (index < list.length) {
          result.add(list[index]);
          added = true;
        }
      }
      if (!added) break; // all lists exhausted
      index++;
    }

    return result;
  }
}
