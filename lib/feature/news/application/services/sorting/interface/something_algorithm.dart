import 'package:interview/feature/news/domain/entities/news_entities.dart';

/// Interface for news sorting algorithms
/// Follows Single Responsibility Principle (SRP)
abstract class SomethingAlgorithm {
  /// Sorts news items according to the algorithm's logic
  List<NewsEntity> sortNews(List<NewsEntity> news);
}

/// Sequential company arrangement algorithm
/// Sorts news by: 1. Microsoft, 2. Apple, 3. Google, 4. Tesla, then repeats
class SequentialCompanyAlgorithm implements SomethingAlgorithm {
  static const _companyOrder = ['Microsoft', 'Apple', 'Google', 'Tesla'];

  @override
  List<NewsEntity> sortNews(List<NewsEntity> news) {
    // First, sort by date (newest first)
    final sortedByDate = List<NewsEntity>.from(news)
      ..sort((a, b) {
        final dateA = a.publishedAt ?? DateTime(1970);
        final dateB = b.publishedAt ?? DateTime(1970);
        return dateB.compareTo(dateA); // Newest first
      });

    // Then arrange by sequential company order
    final result = <NewsEntity>[];
    final companyGroups = <String, List<NewsEntity>>{};

    // Group news by company
    for (final item in sortedByDate) {
      final company = _extractCompanyFromTitle(item.title ?? '');
      companyGroups.putIfAbsent(company, () => []).add(item);
    }

    // Arrange in sequential order
    int index = 0;
    while (companyGroups.isNotEmpty) {
      final company = _companyOrder[index % _companyOrder.length];
      if (companyGroups.containsKey(company) &&
          companyGroups[company]!.isNotEmpty) {
        result.add(companyGroups[company]!.removeAt(0));
        if (companyGroups[company]!.isEmpty) {
          companyGroups.remove(company);
        }
      }
      index++;

      // Safety check to prevent infinite loop
      if (index > 1000) break;
    }

    return result;
  }

  /// Extracts company name from news title
  String _extractCompanyFromTitle(String title) {
    final lowerTitle = title.toLowerCase();
    for (final company in _companyOrder) {
      if (lowerTitle.contains(company.toLowerCase())) {
        return company;
      }
    }
    return 'Unknown';
  }
}
