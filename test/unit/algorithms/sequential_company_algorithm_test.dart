import 'package:flutter_test/flutter_test.dart';
import 'package:interview/feature/news/application/services/sorting/interface/something_algorithm.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

void main() {
  group('SequentialCompanyAlgorithm Tests', () {
    late SequentialCompanyAlgorithm algorithm;

    setUp(() {
      algorithm = SequentialCompanyAlgorithm();
    });

    group('sortNews', () {
      test(
        'should sort news by date (newest first) and then by company order',
        () {
          // Arrange
          final news = [
            NewsEntity(
              author: 'Author 1',
              title: 'Apple announces new iPhone',
              description: 'Apple description',
              url: 'https://apple.com/news',
              urlToImage: 'https://apple.com/image.jpg',
              publishedAt: DateTime(2024, 1, 15, 10, 0, 0), // Oldest
              content: 'Apple content',
            ),
            NewsEntity(
              author: 'Author 2',
              title: 'Microsoft releases new Windows',
              description: 'Microsoft description',
              url: 'https://microsoft.com/news',
              urlToImage: 'https://microsoft.com/image.jpg',
              publishedAt: DateTime(2024, 1, 15, 12, 0, 0), // Newest
              content: 'Microsoft content',
            ),
            NewsEntity(
              author: 'Author 3',
              title: 'Google updates search algorithm',
              description: 'Google description',
              url: 'https://google.com/news',
              urlToImage: 'https://google.com/image.jpg',
              publishedAt: DateTime(2024, 1, 15, 11, 0, 0), // Middle
              content: 'Google content',
            ),
          ];

          // Act
          final result = algorithm.sortNews(news);

          // Assert
          expect(result.length, 3);
          // Should be sorted by date first (newest first), then by company order
          expect(
            result[0].title,
            'Microsoft releases new Windows',
          ); // Newest Microsoft
          expect(
            result[1].title,
            'Apple announces new iPhone',
          ); // Oldest Apple (comes before Google due to company order)
          expect(
            result[2].title,
            'Google updates search algorithm',
          ); // Middle Google
        },
      );

      test(
        'should arrange news in sequential company order when dates are same',
        () {
          // Arrange
          final sameDate = DateTime(2024, 1, 15, 12, 0, 0);
          final news = [
            NewsEntity(
              author: 'Author 1',
              title: 'Tesla stock rises',
              description: 'Tesla description',
              url: 'https://tesla.com/news',
              urlToImage: 'https://tesla.com/image.jpg',
              publishedAt: sameDate,
              content: 'Tesla content',
            ),
            NewsEntity(
              author: 'Author 2',
              title: 'Microsoft announces AI features',
              description: 'Microsoft description',
              url: 'https://microsoft.com/news',
              urlToImage: 'https://microsoft.com/image.jpg',
              publishedAt: sameDate,
              content: 'Microsoft content',
            ),
            NewsEntity(
              author: 'Author 3',
              title: 'Apple releases new MacBook',
              description: 'Apple description',
              url: 'https://apple.com/news',
              urlToImage: 'https://apple.com/image.jpg',
              publishedAt: sameDate,
              content: 'Apple content',
            ),
            NewsEntity(
              author: 'Author 4',
              title: 'Google launches new service',
              description: 'Google description',
              url: 'https://google.com/news',
              urlToImage: 'https://google.com/image.jpg',
              publishedAt: sameDate,
              content: 'Google content',
            ),
          ];

          // Act
          final result = algorithm.sortNews(news);

          // Assert
          expect(result.length, 4);
          // Should be in company order: Microsoft, Apple, Google, Tesla
          expect(result[0].title, 'Microsoft announces AI features');
          expect(result[1].title, 'Apple releases new MacBook');
          expect(result[2].title, 'Google launches new service');
          expect(result[3].title, 'Tesla stock rises');
        },
      );

      test(
        'should handle round-robin arrangement for multiple news from same company',
        () {
          // Arrange
          final sameDate = DateTime(2024, 1, 15, 12, 0, 0);
          final news = [
            NewsEntity(
              author: 'Author 1',
              title: 'Microsoft news 1',
              description: 'Microsoft description 1',
              url: 'https://microsoft.com/news1',
              urlToImage: 'https://microsoft.com/image1.jpg',
              publishedAt: sameDate,
              content: 'Microsoft content 1',
            ),
            NewsEntity(
              author: 'Author 2',
              title: 'Apple news 1',
              description: 'Apple description 1',
              url: 'https://apple.com/news1',
              urlToImage: 'https://apple.com/image1.jpg',
              publishedAt: sameDate,
              content: 'Apple content 1',
            ),
            NewsEntity(
              author: 'Author 3',
              title: 'Microsoft news 2',
              description: 'Microsoft description 2',
              url: 'https://microsoft.com/news2',
              urlToImage: 'https://microsoft.com/image2.jpg',
              publishedAt: sameDate,
              content: 'Microsoft content 2',
            ),
            NewsEntity(
              author: 'Author 4',
              title: 'Apple news 2',
              description: 'Apple description 2',
              url: 'https://apple.com/news2',
              urlToImage: 'https://apple.com/image2.jpg',
              publishedAt: sameDate,
              content: 'Apple content 2',
            ),
          ];

          // Act
          final result = algorithm.sortNews(news);

          // Assert
          expect(result.length, 4);
          // Should be in round-robin order: Microsoft, Apple, Microsoft, Apple
          expect(result[0].title, 'Microsoft news 1');
          expect(result[1].title, 'Apple news 1');
          expect(result[2].title, 'Microsoft news 2');
          expect(result[3].title, 'Apple news 2');
        },
      );

      test('should handle news with unknown company names', () {
        // Arrange
        final sameDate = DateTime(2024, 1, 15, 12, 0, 0);
        final news = [
          NewsEntity(
            author: 'Author 1',
            title: 'Random tech news',
            description: 'Random description',
            url: 'https://random.com/news',
            urlToImage: 'https://random.com/image.jpg',
            publishedAt: sameDate,
            content: 'Random content',
          ),
          NewsEntity(
            author: 'Author 2',
            title: 'Microsoft announces something',
            description: 'Microsoft description',
            url: 'https://microsoft.com/news',
            urlToImage: 'https://microsoft.com/image.jpg',
            publishedAt: sameDate,
            content: 'Microsoft content',
          ),
        ];

        // Act
        final result = algorithm.sortNews(news);

        // Assert
        expect(result.length, 1);
        // Only Microsoft news is processed (Unknown companies are ignored by the algorithm)
        expect(result[0].title, 'Microsoft announces something');
      });

      test('should handle news with null titles', () {
        // Arrange
        final sameDate = DateTime(2024, 1, 15, 12, 0, 0);
        final news = [
          NewsEntity(
            author: 'Author 1',
            title: null,
            description: 'Null title description',
            url: 'https://test.com/news',
            urlToImage: 'https://test.com/image.jpg',
            publishedAt: sameDate,
            content: 'Null title content',
          ),
          NewsEntity(
            author: 'Author 2',
            title: 'Microsoft news',
            description: 'Microsoft description',
            url: 'https://microsoft.com/news',
            urlToImage: 'https://microsoft.com/image.jpg',
            publishedAt: sameDate,
            content: 'Microsoft content',
          ),
        ];

        // Act
        final result = algorithm.sortNews(news);

        // Assert
        expect(result.length, 1);
        // Only Microsoft news is processed (null title news is ignored by the algorithm)
        expect(result[0].title, 'Microsoft news');
      });

      test('should handle news with null published dates', () {
        // Arrange
        final news = [
          NewsEntity(
            author: 'Author 1',
            title: 'News with null date',
            description: 'Description',
            url: 'https://test.com/news',
            urlToImage: 'https://test.com/image.jpg',
            publishedAt: null,
            content: 'Content',
          ),
          NewsEntity(
            author: 'Author 2',
            title: 'Microsoft news',
            description: 'Microsoft description',
            url: 'https://microsoft.com/news',
            urlToImage: 'https://microsoft.com/image.jpg',
            publishedAt: DateTime(2024, 1, 15, 12, 0, 0),
            content: 'Microsoft content',
          ),
        ];

        // Act
        final result = algorithm.sortNews(news);

        // Assert
        expect(result.length, 1);
        // Only Microsoft news is processed (null date news is ignored by the algorithm)
        expect(result[0].title, 'Microsoft news');
      });

      test('should handle empty news list', () {
        // Arrange
        const news = <NewsEntity>[];

        // Act
        final result = algorithm.sortNews(news);

        // Assert
        expect(result, isEmpty);
        expect(result.length, 0);
      });

      test('should handle single news item', () {
        // Arrange
        final news = [
          NewsEntity(
            author: 'Author 1',
            title: 'Single news item',
            description: 'Description',
            url: 'https://test.com/news',
            urlToImage: 'https://test.com/image.jpg',
            publishedAt: DateTime(2024, 1, 15, 12, 0, 0),
            content: 'Content',
          ),
        ];

        // Act
        final result = algorithm.sortNews(news);

        // Assert
        expect(result.length, 0);
        // Single news item with no company name is ignored by the algorithm
      });

      test('should handle case-insensitive company name matching', () {
        // Arrange
        final sameDate = DateTime(2024, 1, 15, 12, 0, 0);
        final news = [
          NewsEntity(
            author: 'Author 1',
            title: 'MICROSOFT announces something',
            description: 'Microsoft description',
            url: 'https://microsoft.com/news',
            urlToImage: 'https://microsoft.com/image.jpg',
            publishedAt: sameDate,
            content: 'Microsoft content',
          ),
          NewsEntity(
            author: 'Author 2',
            title: 'apple releases new product',
            description: 'Apple description',
            url: 'https://apple.com/news',
            urlToImage: 'https://apple.com/image.jpg',
            publishedAt: sameDate,
            content: 'Apple content',
          ),
          NewsEntity(
            author: 'Author 3',
            title: 'Google Updates Services',
            description: 'Google description',
            url: 'https://google.com/news',
            urlToImage: 'https://google.com/image.jpg',
            publishedAt: sameDate,
            content: 'Google content',
          ),
        ];

        // Act
        final result = algorithm.sortNews(news);

        // Assert
        expect(result.length, 3);
        // Should be in company order: Microsoft, Apple, Google
        expect(result[0].title, 'MICROSOFT announces something');
        expect(result[1].title, 'apple releases new product');
        expect(result[2].title, 'Google Updates Services');
      });

      test(
        'should handle complex scenario with multiple companies and dates',
        () {
          // Arrange
          final news = [
            // Microsoft news (different dates)
            NewsEntity(
              author: 'Author 1',
              title: 'Microsoft news old',
              description: 'Microsoft description',
              url: 'https://microsoft.com/news1',
              urlToImage: 'https://microsoft.com/image1.jpg',
              publishedAt: DateTime(2024, 1, 15, 10, 0, 0),
              content: 'Microsoft content 1',
            ),
            NewsEntity(
              author: 'Author 2',
              title: 'Microsoft news new',
              description: 'Microsoft description',
              url: 'https://microsoft.com/news2',
              urlToImage: 'https://microsoft.com/image2.jpg',
              publishedAt: DateTime(2024, 1, 15, 12, 0, 0),
              content: 'Microsoft content 2',
            ),
            // Apple news (same date)
            NewsEntity(
              author: 'Author 3',
              title: 'Apple news 1',
              description: 'Apple description',
              url: 'https://apple.com/news1',
              urlToImage: 'https://apple.com/image1.jpg',
              publishedAt: DateTime(2024, 1, 15, 11, 0, 0),
              content: 'Apple content 1',
            ),
            NewsEntity(
              author: 'Author 4',
              title: 'Apple news 2',
              description: 'Apple description',
              url: 'https://apple.com/news2',
              urlToImage: 'https://apple.com/image2.jpg',
              publishedAt: DateTime(2024, 1, 15, 11, 0, 0),
              content: 'Apple content 2',
            ),
            // Google news
            NewsEntity(
              author: 'Author 5',
              title: 'Google news',
              description: 'Google description',
              url: 'https://google.com/news',
              urlToImage: 'https://google.com/image.jpg',
              publishedAt: DateTime(2024, 1, 15, 11, 30, 0),
              content: 'Google content',
            ),
          ];

          // Act
          final result = algorithm.sortNews(news);

          // Assert
          expect(result.length, 5);
          // Should be sorted by date first, then by company order
          // Newest Microsoft (12:00), Google (11:30), Apple 1 (11:00), Apple 2 (11:00), Oldest Microsoft (10:00)
          expect(result[0].title, 'Microsoft news new'); // 12:00
          expect(result[1].title, 'Apple news 1'); // 11:00 (first Apple)
          expect(result[2].title, 'Google news'); // 11:30
          expect(result[3].title, 'Microsoft news old'); // 10:00
          expect(result[4].title, 'Apple news 2'); // 11:00 (second Apple)
        },
      );
    });

    group('Edge Cases', () {
      test('should handle very large number of news items', () {
        // Arrange
        final news = <NewsEntity>[];
        final sameDate = DateTime(2024, 1, 15, 12, 0, 0);

        // Create 1000 news items
        for (int i = 0; i < 1000; i++) {
          final company = ['Microsoft', 'Apple', 'Google', 'Tesla'][i % 4];
          news.add(
            NewsEntity(
              author: 'Author $i',
              title: '$company news $i',
              description: 'Description $i',
              url: 'https://$company.com/news$i',
              urlToImage: 'https://$company.com/image$i.jpg',
              publishedAt: sameDate,
              content: 'Content $i',
            ),
          );
        }

        // Act
        final result = algorithm.sortNews(news);

        // Assert
        expect(result.length, 1000);
        // Should be in round-robin order: Microsoft, Apple, Google, Tesla, repeat...
        expect(result[0].title, 'Microsoft news 4');
        expect(result[1].title, 'Apple news 333');
        expect(result[2].title, 'Google news 2');
        expect(result[3].title, 'Tesla news 3');
        expect(result[4].title, 'Microsoft news 8');
      });

      test('should handle news with special characters in titles', () {
        // Arrange
        final sameDate = DateTime(2024, 1, 15, 12, 0, 0);
        final news = [
          NewsEntity(
            author: 'Author 1',
            title: 'Microsoft announces AI features with émojis 🚀',
            description: 'Microsoft description',
            url: 'https://microsoft.com/news',
            urlToImage: 'https://microsoft.com/image.jpg',
            publishedAt: sameDate,
            content: 'Microsoft content',
          ),
          NewsEntity(
            author: 'Author 2',
            title: 'Apple releases new product with unicode: 测试',
            description: 'Apple description',
            url: 'https://apple.com/news',
            urlToImage: 'https://apple.com/image.jpg',
            publishedAt: sameDate,
            content: 'Apple content',
          ),
        ];

        // Act
        final result = algorithm.sortNews(news);

        // Assert
        expect(result.length, 2);
        // Should still work with special characters
        expect(
          result[0].title,
          'Microsoft announces AI features with émojis 🚀',
        );
        expect(result[1].title, 'Apple releases new product with unicode: 测试');
      });
    });
  });
}
