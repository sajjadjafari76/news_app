import 'package:flutter_test/flutter_test.dart';
import 'package:interview/feature/news/application/params/news_params.dart';
import 'package:interview/feature/news/data/datasource/interface/news_remote_datasource.dart';
import 'package:interview/feature/news/data/datasource/news_api_datasource.dart';
import 'package:interview/feature/news/data/models/news_model.dart';
import 'package:interview/core/network/interface/i_api_request_manager.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockHttpClient extends Mock implements IHttpClient {}

void main() {
  group('NewsRemoteDataSourceIml Tests', () {
    late NewsRemoteDataSourceIml dataSource;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      dataSource = NewsRemoteDataSourceIml(mockHttpClient);
    });

    group('getNews', () {
      test('should return news models when API call succeeds', () async {
        // Arrange
        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        final mockResponse = {
          'status': 'ok',
          'totalResults': 2,
          'articles': [
            {
              'author': 'John Doe',
              'title': 'Microsoft announces new features',
              'description': 'Microsoft has announced new AI features',
              'url': 'https://microsoft.com/news',
              'urlToImage': 'https://microsoft.com/image.jpg',
              'publishedAt': '2024-01-15T12:00:00',
              'content': 'Full article content about Microsoft features',
            },
            {
              'author': 'Jane Smith',
              'title': 'Microsoft stock rises',
              'description': 'Microsoft stock has seen significant growth',
              'url': 'https://microsoft.com/stock',
              'urlToImage': 'https://microsoft.com/stock-image.jpg',
              'publishedAt': '2024-01-15T13:00:00',
              'content': 'Full article content about Microsoft stock',
            },
          ],
        };

        when(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dataSource.getNews(params);

        // Assert
        expect(result, isA<List<NewsModel>>());
        expect(result.length, 2);
        expect(result[0].title, 'Microsoft announces new features');
        expect(result[0].author, 'John Doe');
        expect(
          result[0].description,
          'Microsoft has announced new AI features',
        );
        expect(result[0].url, 'https://microsoft.com/news');
        expect(result[0].urlToImage, 'https://microsoft.com/image.jpg');
        expect(result[0].publishedAt, DateTime(2024, 1, 15, 12, 0, 0));
        expect(
          result[0].content,
          'Full article content about Microsoft features',
        );

        expect(result[1].title, 'Microsoft stock rises');
        expect(result[1].author, 'Jane Smith');

        verify(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });

      test('should handle API response with null values', () async {
        // Arrange
        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        final mockResponse = {
          'status': 'ok',
          'totalResults': 1,
          'articles': [
            {
              'author': null,
              'title': null,
              'description': null,
              'url': null,
              'urlToImage': null,
              'publishedAt': null,
              'content': null,
            },
          ],
        };

        when(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dataSource.getNews(params);

        // Assert
        expect(result, isA<List<NewsModel>>());
        expect(result.length, 1);
        expect(result[0].author, isNull);
        expect(result[0].title, isNull);
        expect(result[0].description, isNull);
        expect(result[0].url, isNull);
        expect(result[0].urlToImage, isNull);
        expect(result[0].publishedAt, isNull);
        expect(result[0].content, isNull);
      });

      test('should handle empty API response', () async {
        // Arrange
        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        when(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => {'status': 'ok', 'totalResults': 0, 'articles': []},
        );

        // Act
        final result = await dataSource.getNews(params);

        // Assert
        expect(result, isA<List<NewsModel>>());
        expect(result, isEmpty);
        expect(result.length, 0);
      });

      test('should handle invalid date format in API response', () async {
        // Arrange
        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        final mockResponse = {
          'status': 'ok',
          'totalResults': 1,
          'articles': [
            {
              'author': 'John Doe',
              'title': 'Test News',
              'description': 'Test Description',
              'url': 'https://test.com/news',
              'urlToImage': 'https://test.com/image.jpg',
              'publishedAt': 'invalid-date-format',
              'content': 'Test Content',
            },
          ],
        };

        when(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dataSource.getNews(params);

        // Assert
        expect(result, isA<List<NewsModel>>());
        expect(result.length, 1);
        expect(result[0].title, 'Test News');
        expect(
          result[0].publishedAt,
          isNull,
        ); // Should be null due to invalid date
      });

      test('should handle API throwing exception', () async {
        // Arrange
        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        when(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => dataSource.getNews(params), throwsA(isA<Exception>()));

        verify(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      });


    });

    group('Edge Cases', () {
      test('should handle malformed JSON response', () async {
        // Arrange
        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        when(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => 'invalid json');

        // Act & Assert
        expect(() => dataSource.getNews(params), throwsA(isA<TypeError>()));
      });

      test('should handle very large response', () async {
        // Arrange
        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        final largeResponse = {
          'status': 'ok',
          'totalResults': 1000,
          'articles': List.generate(
            1000,
            (index) => {
              'author': 'Author $index',
              'title': 'News $index',
              'description': 'Description $index',
              'url': 'https://test.com/news$index',
              'urlToImage': 'https://test.com/image$index.jpg',
              'publishedAt': '2024-01-15T12:00:00Z',
              'content': 'Content $index',
            },
          ),
        };

        when(
          () => mockHttpClient.getRequest(
            path: '/everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => largeResponse);

        // Act
        final result = await dataSource.getNews(params);

        // Assert
        expect(result, isA<List<NewsModel>>());
        expect(result.length, 1000);
        expect(result[0].title, 'News 0');
        expect(result[999].title, 'News 999');
      });
    });
  });
}
