import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview/feature/news/application/params/news_params.dart';
import 'package:interview/feature/news/data/datasource/interface/news_local_datasource.dart';
import 'package:interview/feature/news/data/datasource/interface/news_remote_datasource.dart';
import 'package:interview/feature/news/data/models/news_model.dart';
import 'package:interview/feature/news/data/repository/news_repository.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';
import 'package:interview/feature/news/domain/failure/failures.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

class MockNewsLocalDataSource extends Mock implements NewsLocalDataSource {}

void main() {
  group('HomeRepositoryImp Tests', () {
    late HomeRepositoryImp repository;
    late MockNewsRemoteDataSource mockRemoteDataSource;
    late MockNewsLocalDataSource mockLocalDataSource;

    setUpAll(() {
      registerFallbackValue(
        NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        ),
      );
    });

    setUp(() {
      mockRemoteDataSource = MockNewsRemoteDataSource();
      mockLocalDataSource = MockNewsLocalDataSource();
      repository = HomeRepositoryImp(mockLocalDataSource, mockRemoteDataSource);
    });

    group('getNews', () {
      test(
        'should return news entities when remote data source succeeds',
        () async {
          // Arrange
          final testDate = DateTime(2024, 1, 15, 12, 0, 0);
          final newsModels = [
            NewsModel(
              author: 'John Doe',
              title: 'Test News',
              description: 'Test Description',
              url: 'https://test.com/news',
              urlToImage: 'https://test.com/image.jpg',
              publishedAt: testDate,
              content: 'Test Content',
            ),
          ];

          final expectedEntities = [
            NewsEntity(
              author: 'John Doe',
              title: 'Test News',
              description: 'Test Description',
              url: 'https://test.com/news',
              urlToImage: 'https://test.com/image.jpg',
              publishedAt: testDate,
              content: 'Test Content',
            ),
          ];

          final params = NewsParams.create(
            company: 'Microsoft',
            fromDate: DateTime(2024, 1, 14),
            toDate: DateTime(2024, 1, 15),
          );

          when(
            () => mockRemoteDataSource.getNews(params),
          ).thenAnswer((_) async => newsModels);
          when(
            () => mockLocalDataSource.cacheNews('Microsoft', newsModels),
          ).thenAnswer((_) async {});

          // Act
          final result = await repository.getNews(params);

          // Assert
          expect(result, isA<Right<Failure, List<NewsEntity>>>());
          result.fold((failure) => fail('Should not return failure'), (
            entities,
          ) {
            expect(entities, equals(expectedEntities));
            expect(entities.length, 1);
            expect(entities[0].title, 'Test News');
            expect(entities[0].author, 'John Doe');
          });

          verify(() => mockRemoteDataSource.getNews(params)).called(1);
          verify(
            () => mockLocalDataSource.cacheNews('Microsoft', newsModels),
          ).called(1);
        },
      );

      test('should return cached news when remote data source fails', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 15, 12, 0, 0);
        final cachedModels = [
          NewsModel(
            author: 'Cached Author',
            title: 'Cached News',
            description: 'Cached Description',
            url: 'https://cached.com/news',
            urlToImage: 'https://cached.com/image.jpg',
            publishedAt: testDate,
            content: 'Cached Content',
          ),
        ];

        final expectedEntities = [
          NewsEntity(
            author: 'Cached Author',
            title: 'Cached News',
            description: 'Cached Description',
            url: 'https://cached.com/news',
            urlToImage: 'https://cached.com/image.jpg',
            publishedAt: testDate,
            content: 'Cached Content',
          ),
        ];

        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        when(
          () => mockRemoteDataSource.getNews(params),
        ).thenThrow(Exception('Network error'));
        when(
          () => mockLocalDataSource.getCachedNews('Microsoft'),
        ).thenAnswer((_) async => cachedModels);

        // Act
        final result = await repository.getNews(params);

        // Assert
        expect(result, isA<Right<Failure, List<NewsEntity>>>());
        result.fold((failure) => fail('Should not return failure'), (entities) {
          expect(entities, equals(expectedEntities));
          expect(entities.length, 1);
          expect(entities[0].title, 'Cached News');
          expect(entities[0].author, 'Cached Author');
        });

        verify(() => mockRemoteDataSource.getNews(params)).called(1);
        verify(() => mockLocalDataSource.getCachedNews('Microsoft')).called(1);
      });

      test(
        'should return server failure when remote fails and cache is empty',
        () async {
          // Arrange
          final params = NewsParams.create(
            company: 'Microsoft',
            fromDate: DateTime(2024, 1, 14),
            toDate: DateTime(2024, 1, 15),
          );

          when(
            () => mockRemoteDataSource.getNews(params),
          ).thenThrow(Exception('Network error'));
          when(
            () => mockLocalDataSource.getCachedNews('Microsoft'),
          ).thenAnswer((_) async => []);

          // Act
          final result = await repository.getNews(params);

          // Assert
          expect(result, isA<Left<Failure, List<NewsEntity>>>());
          result.fold((failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, 'Exception: Network error');
          }, (entities) => fail('Should not return entities'));

          verify(() => mockRemoteDataSource.getNews(params)).called(1);
          verify(
            () => mockLocalDataSource.getCachedNews('Microsoft'),
          ).called(1);
        },
      );

      test(
        'should return cache failure when both remote and cache fail',
        () async {
          // Arrange
          final params = NewsParams.create(
            company: 'Microsoft',
            fromDate: DateTime(2024, 1, 14),
            toDate: DateTime(2024, 1, 15),
          );

          when(
            () => mockRemoteDataSource.getNews(params),
          ).thenThrow(Exception('Network error'));
          when(
            () => mockLocalDataSource.getCachedNews('Microsoft'),
          ).thenThrow(Exception('Cache error'));

          // Act
          final result = await repository.getNews(params);

          // Assert
          expect(result, isA<Left<Failure, List<NewsEntity>>>());
          result.fold((failure) {
            expect(failure, isA<CacheFailure>());
            expect(failure.message, 'Exception: Cache error');
          }, (entities) => fail('Should not return entities'));

          verify(() => mockRemoteDataSource.getNews(params)).called(1);
          verify(
            () => mockLocalDataSource.getCachedNews('Microsoft'),
          ).called(1);
        },
      );

      test('should handle multiple news items', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 15, 12, 0, 0);
        final newsModels = [
          NewsModel(
            author: 'Author 1',
            title: 'News 1',
            description: 'Description 1',
            url: 'https://test.com/news1',
            urlToImage: 'https://test.com/image1.jpg',
            publishedAt: testDate,
            content: 'Content 1',
          ),
          NewsModel(
            author: 'Author 2',
            title: 'News 2',
            description: 'Description 2',
            url: 'https://test.com/news2',
            urlToImage: 'https://test.com/image2.jpg',
            publishedAt: testDate.add(const Duration(hours: 1)),
            content: 'Content 2',
          ),
        ];

        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        when(
          () => mockRemoteDataSource.getNews(params),
        ).thenAnswer((_) async => newsModels);
        when(
          () => mockLocalDataSource.cacheNews('Microsoft', newsModels),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.getNews(params);

        // Assert
        expect(result, isA<Right<Failure, List<NewsEntity>>>());
        result.fold((failure) => fail('Should not return failure'), (entities) {
          expect(entities.length, 2);
          expect(entities[0].title, 'News 1');
          expect(entities[1].title, 'News 2');
        });
      });

      test('should handle news with null values', () async {
        // Arrange
        final newsModels = [
          NewsModel(
            author: null,
            title: null,
            description: null,
            url: null,
            urlToImage: null,
            publishedAt: null,
            content: null,
          ),
        ];

        final params = NewsParams.create(
          company: 'Microsoft',
          fromDate: DateTime(2024, 1, 14),
          toDate: DateTime(2024, 1, 15),
        );

        when(
          () => mockRemoteDataSource.getNews(params),
        ).thenAnswer((_) async => newsModels);
        when(
          () => mockLocalDataSource.cacheNews('Microsoft', newsModels),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.getNews(params);

        // Assert
        expect(result, isA<Right<Failure, List<NewsEntity>>>());
        result.fold((failure) => fail('Should not return failure'), (entities) {
          expect(entities.length, 1);
          expect(entities[0].author, isNull);
          expect(entities[0].title, isNull);
          expect(entities[0].description, isNull);
          expect(entities[0].url, isNull);
          expect(entities[0].urlToImage, isNull);
          expect(entities[0].publishedAt, isNull);
          expect(entities[0].content, isNull);
        });
      });
    });

    group('getCachedNews', () {
      test('should return cached news entities when successful', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 15, 12, 0, 0);
        final cachedModels = [
          NewsModel(
            author: 'Cached Author',
            title: 'Cached News',
            description: 'Cached Description',
            url: 'https://cached.com/news',
            urlToImage: 'https://cached.com/image.jpg',
            publishedAt: testDate,
            content: 'Cached Content',
          ),
        ];

        when(
          () => mockLocalDataSource.getCachedNews('Microsoft'),
        ).thenAnswer((_) async => cachedModels);

        // Act
        final result = await repository.getCachedNews('Microsoft');

        // Assert
        expect(result, isA<Right<Failure, List<NewsEntity>>>());
        result.fold((failure) => fail('Should not return failure'), (entities) {
          expect(entities.length, 1);
          expect(entities[0].title, 'Cached News');
          expect(entities[0].author, 'Cached Author');
        });

        verify(() => mockLocalDataSource.getCachedNews('Microsoft')).called(1);
      });

      test(
        'should return cache failure when local data source fails',
        () async {
          // Arrange
          when(
            () => mockLocalDataSource.getCachedNews('Microsoft'),
          ).thenThrow(Exception('Cache read error'));

          // Act
          final result = await repository.getCachedNews('Microsoft');

          // Assert
          expect(result, isA<Left<Failure, List<NewsEntity>>>());
          result.fold((failure) {
            expect(failure, isA<CacheFailure>());
            expect(failure.message, 'Exception: Cache read error');
          }, (entities) => fail('Should not return entities'));

          verify(
            () => mockLocalDataSource.getCachedNews('Microsoft'),
          ).called(1);
        },
      );

      test('should return empty list when no cached news exists', () async {
        // Arrange
        when(
          () => mockLocalDataSource.getCachedNews('Microsoft'),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repository.getCachedNews('Microsoft');

        // Assert
        expect(result, isA<Right<Failure, List<NewsEntity>>>());
        result.fold((failure) => fail('Should not return failure'), (entities) {
          expect(entities, isEmpty);
        });

        verify(() => mockLocalDataSource.getCachedNews('Microsoft')).called(1);
      });
    });

    group('cacheNews', () {
      test('should cache news entities successfully', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 15, 12, 0, 0);
        final newsEntities = [
          NewsEntity(
            author: 'Test Author',
            title: 'Test News',
            description: 'Test Description',
            url: 'https://test.com/news',
            urlToImage: 'https://test.com/image.jpg',
            publishedAt: testDate,
            content: 'Test Content',
          ),
        ];

        when(
          () => mockLocalDataSource.cacheNews('Microsoft', any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.cacheNews('Microsoft', newsEntities);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (_) => expect(true, isTrue), // void return
        );

        verify(
          () => mockLocalDataSource.cacheNews('Microsoft', any()),
        ).called(1);
      });

      test('should return cache failure when caching fails', () async {
        // Arrange
        final testDate = DateTime(2024, 1, 15, 12, 0, 0);
        final newsEntities = [
          NewsEntity(
            author: 'Test Author',
            title: 'Test News',
            description: 'Test Description',
            url: 'https://test.com/news',
            urlToImage: 'https://test.com/image.jpg',
            publishedAt: testDate,
            content: 'Test Content',
          ),
        ];

        when(
          () => mockLocalDataSource.cacheNews('Microsoft', any()),
        ).thenThrow(Exception('Cache write error'));

        // Act
        final result = await repository.cacheNews('Microsoft', newsEntities);

        // Assert
        expect(result, isA<Left<Failure, void>>());
        result.fold((failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, 'Exception: Cache write error');
        }, (_) => fail('Should not return success'));

        verify(
          () => mockLocalDataSource.cacheNews('Microsoft', any()),
        ).called(1);
      });

      test('should handle empty news list', () async {
        // Arrange
        const newsEntities = <NewsEntity>[];

        when(
          () => mockLocalDataSource.cacheNews('Microsoft', any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.cacheNews('Microsoft', newsEntities);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (_) => expect(true, isTrue), // void return
        );

        verify(
          () => mockLocalDataSource.cacheNews('Microsoft', any()),
        ).called(1);
      });

      test('should handle news with null values', () async {
        // Arrange
        final newsEntities = [
          NewsEntity(
            author: null,
            title: null,
            description: null,
            url: null,
            urlToImage: null,
            publishedAt: null,
            content: null,
          ),
        ];

        when(
          () => mockLocalDataSource.cacheNews('Microsoft', any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.cacheNews('Microsoft', newsEntities);

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Should not return failure'),
          (_) => expect(true, isTrue), // void return
        );

        verify(
          () => mockLocalDataSource.cacheNews('Microsoft', any()),
        ).called(1);
      });
    });

    group('Edge Cases', () {
      test('should handle different company names', () async {
        // Arrange
        final companies = ['Microsoft', 'Apple', 'Google', 'Tesla'];
        final testDate = DateTime(2024, 1, 15, 12, 0, 0);
        final newsModels = [
          NewsModel(
            author: 'Test Author',
            title: 'Test News',
            description: 'Test Description',
            url: 'https://test.com/news',
            urlToImage: 'https://test.com/image.jpg',
            publishedAt: testDate,
            content: 'Test Content',
          ),
        ];

        when(
          () => mockRemoteDataSource.getNews(any()),
        ).thenAnswer((_) async => newsModels);
        when(
          () => mockLocalDataSource.cacheNews(any(), any()),
        ).thenAnswer((_) async {});

        // Act & Assert
        for (final company in companies) {
          final params = NewsParams.create(
            company: company,
            fromDate: DateTime(2024, 1, 14),
            toDate: DateTime(2024, 1, 15),
          );

          final result = await repository.getNews(params);

          expect(result, isA<Right<Failure, List<NewsEntity>>>());
          result.fold(
            (failure) => fail('Should not return failure for $company'),
            (entities) {
              expect(entities.length, 1);
              expect(entities[0].title, 'Test News');
            },
          );
        }

        verify(() => mockRemoteDataSource.getNews(any())).called(4);
        verify(() => mockLocalDataSource.cacheNews(any(), any())).called(4);
      });
    });
  });
}
