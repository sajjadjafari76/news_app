// import 'package:interview/core/constants/constants.dart';
// import 'package:interview/core/network/dio_request_manager.dart';
// import 'package:interview/feature/news/application/usecases/news_use_case.dart';
// import 'package:interview/feature/news/data/datasource/news_api_datasource.dart';
// import 'package:interview/feature/news/data/repository/news_repository.dart';
//
// import 'application/params/news_params.dart';
// import 'application/services/sorting/sequential_algorithm.dart';
//
// /// This is a standalone runner to test the news fetching logic without Flutter.
// /// To run this file, open your terminal and execute:
// /// dart run lib/news_console_runner.dart
// void main() async {
//   print('--- Starting News Fetching Test ---');
//
//   // 1. Setup Dependencies
//   // Network Layer
//   final dioHttpClient = DioHttpClient(Constants.baseUrl);
//
//   // Data Layer
//   final newsDataSource = NewsDataSourceIml(dioHttpClient);
//   final newsRepository = HomeRepositoryImp(newsDataSource);
//
//   // Application Layer
//   final sortingAlgorithm = SequentialAlgorithm();
//   final newsUseCase = NewsUseCase(
//     repository: newsRepository,
//     algorithm: sortingAlgorithm,
//   );
//
//   // 2. Define Parameters
//   final params = NewsParams(q: 'tesla', page: 1, pageSize: 50);
//
//   print('Fetching news for query: "${params.q}"...\n');
//
//   // 3. Execute the Use Case
//   final result = await newsUseCase(params);
//
//   // 4. Handle and Print the Result
//   result.fold(
//     (failure) {
//       print('--- FAILED ---');
//       print('Error Type: ${failure.title}');
//       print('Error Message: ${failure.message}');
//     },
//     (newsList) {
//       print('--- SUCCESS ---');
//       print('Fetched ${newsList.length} articles:\n');
//       for (var i = 0; i < newsList.length; i++) {
//         final news = newsList[i];
//         print('  ${i + 1}. ${news.title}');
//         print('     - Author: ${news.author ?? 'N/A'}\n');
//       }
//     },
//   );
//
//   print('\n--- Test Finished ---');
// }
