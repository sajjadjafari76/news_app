import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interview/core/usecase/usecase.dart';
import 'package:interview/feature/news/application/services/news_service.dart';
import 'package:interview/feature/news/application/usecases/news_use_case.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';
import 'package:interview/feature/news/domain/failure/failures.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockNewsService extends Mock implements NewsService {}

void main() {
  group('NewsUseCase Tests', () {
    late NewsUseCase useCase;
    late MockNewsService mockNewsService;

    setUp(() {
      mockNewsService = MockNewsService();
      useCase = NewsUseCase(newsService: mockNewsService);
    });

    group('call', () {
      test('should return news list when service call is successful', () async {
        // Arrange
        final testNews = [
          NewsEntity(
            author: 'John Doe',
            title: 'Test News 1',
            description: 'Test Description 1',
            url: 'https://test.com/1',
            urlToImage: 'https://test.com/image1.jpg',
            publishedAt: DateTime(2024, 1, 15, 12, 0, 0),
            content: 'Test Content 1',
          ),
          NewsEntity(
            author: 'Jane Smith',
            title: 'Test News 2',
            description: 'Test Description 2',
            url: 'https://test.com/2',
            urlToImage: 'https://test.com/image2.jpg',
            publishedAt: DateTime(2024, 1, 15, 13, 0, 0),
            content: 'Test Content 2',
          ),
        ];

        when(
          () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
        ).thenAnswer((_) async => Right(testNews));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result, isA<Right<Failure, List<NewsEntity>>>());
        result.fold((failure) => fail('Should not return failure'), (news) {
          expect(news, equals(testNews));
          expect(news.length, 2);
          expect(news[0].title, 'Test News 1');
          expect(news[1].title, 'Test News 2');
        });

        verify(() => mockNewsService.fetchYesterdayToNowNewsFromUs()).called(1);
      });

      test('should return failure when service call fails', () async {
        // Arrange
        const failure = ServerFailure('Failed to fetch news');
        when(
          () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
        ).thenAnswer((_) async => const Left(failure));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result, isA<Left<Failure, List<NewsEntity>>>());
        result.fold((returnedFailure) {
          expect(returnedFailure, equals(failure));
          expect(returnedFailure.message, 'Failed to fetch news');
        }, (news) => fail('Should not return news'));

        verify(() => mockNewsService.fetchYesterdayToNowNewsFromUs()).called(1);
      });

      test(
        'should return network failure when service throws network error',
        () async {
          // Arrange
          const failure = NetworkFailure('No internet connection');
          when(
            () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
          ).thenAnswer((_) async => const Left(failure));

          // Act
          final result = await useCase(NoParams());

          // Assert
          expect(result, isA<Left<Failure, List<NewsEntity>>>());
          result.fold((returnedFailure) {
            expect(returnedFailure, equals(failure));
            expect(returnedFailure.title, 'Network Error');
            expect(returnedFailure.message, 'No internet connection');
          }, (news) => fail('Should not return news'));

          verify(
            () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
          ).called(1);
        },
      );

      test(
        'should return cache failure when service returns cache error',
        () async {
          // Arrange
          const failure = CacheFailure('Failed to load cached data');
          when(
            () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
          ).thenAnswer((_) async => const Left(failure));

          // Act
          final result = await useCase(NoParams());

          // Assert
          expect(result, isA<Left<Failure, List<NewsEntity>>>());
          result.fold((returnedFailure) {
            expect(returnedFailure, equals(failure));
            expect(returnedFailure.title, 'Cache Error');
            expect(returnedFailure.message, 'Failed to load cached data');
          }, (news) => fail('Should not return news'));

          verify(
            () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
          ).called(1);
        },
      );

      test(
        'should return unknown failure when service returns unknown error',
        () async {
          // Arrange
          const failure = UnknownFailure('Something went wrong');
          when(
            () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
          ).thenAnswer((_) async => const Left(failure));

          // Act
          final result = await useCase(NoParams());

          // Assert
          expect(result, isA<Left<Failure, List<NewsEntity>>>());
          result.fold((returnedFailure) {
            expect(returnedFailure, equals(failure));
            expect(returnedFailure.title, 'Error');
            expect(returnedFailure.message, 'Something went wrong');
          }, (news) => fail('Should not return news'));

          verify(
            () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
          ).called(1);
        },
      );

      test('should handle empty news list', () async {
        // Arrange
        const emptyNews = <NewsEntity>[];
        when(
          () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
        ).thenAnswer((_) async => const Right(emptyNews));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result, isA<Right<Failure, List<NewsEntity>>>());
        result.fold((failure) => fail('Should not return failure'), (news) {
          expect(news, isEmpty);
          expect(news.length, 0);
        });

        verify(() => mockNewsService.fetchYesterdayToNowNewsFromUs()).called(1);
      });

      test('should handle news with null values', () async {
        // Arrange
        final newsWithNulls = [
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
          () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
        ).thenAnswer((_) async => Right(newsWithNulls));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result, isA<Right<Failure, List<NewsEntity>>>());
        result.fold((failure) => fail('Should not return failure'), (news) {
          expect(news.length, 1);
          expect(news[0].author, isNull);
          expect(news[0].title, isNull);
          expect(news[0].description, isNull);
          expect(news[0].url, isNull);
          expect(news[0].urlToImage, isNull);
          expect(news[0].publishedAt, isNull);
          expect(news[0].content, isNull);
        });

        verify(() => mockNewsService.fetchYesterdayToNowNewsFromUs()).called(1);
      });
    });

    group('Edge Cases', () {
      test('should handle service throwing exception', () async {
        // Arrange
        when(
          () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
        ).thenThrow(Exception('Unexpected error'));

        // Act & Assert
        expect(() => useCase(NoParams()), throwsA(isA<Exception>()));

        verify(() => mockNewsService.fetchYesterdayToNowNewsFromUs()).called(1);
      });

      test('should handle multiple consecutive calls', () async {
        // Arrange
        final testNews = [
          NewsEntity(
            author: 'Test Author',
            title: 'Test Title',
            description: 'Test Description',
            url: 'https://test.com',
            urlToImage: 'https://test.com/image.jpg',
            publishedAt: DateTime(2024, 1, 15, 12, 0, 0),
            content: 'Test Content',
          ),
        ];

        when(
          () => mockNewsService.fetchYesterdayToNowNewsFromUs(),
        ).thenAnswer((_) async => Right(testNews));

        // Act
        final result1 = await useCase(NoParams());
        final result2 = await useCase(NoParams());
        final result3 = await useCase(NoParams());

        // Assert
        expect(result1, isA<Right<Failure, List<NewsEntity>>>());
        expect(result2, isA<Right<Failure, List<NewsEntity>>>());
        expect(result3, isA<Right<Failure, List<NewsEntity>>>());

        verify(() => mockNewsService.fetchYesterdayToNowNewsFromUs()).called(3);
      });
    });
  });
}
