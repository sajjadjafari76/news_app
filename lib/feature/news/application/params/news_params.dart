import 'package:interview/feature/news/domain/failure/failures.dart';

/// Parameters for news requests with validation
class NewsParams {
  final String company;
  final String country;
  final DateTime fromDate;
  final DateTime toDate;

  const NewsParams({
    required this.company,
    required this.country,
    required this.fromDate,
    required this.toDate,
  });

  /// Validates the company parameter
  static bool isValidCompany(String company) {
    const validCompanies = ['Microsoft', 'Apple', 'Google', 'Tesla'];
    return validCompanies.contains(company);
  }

  /// Creates NewsParams with validation
  factory NewsParams.create({
    required String company,
    required String country,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    if (!isValidCompany(company)) {
      throw const ValidationFailure(
        'Invalid company. Must be one of: Microsoft, Apple, Google, Tesla',
      );
    }

    if (fromDate.isAfter(toDate)) {
      throw const ValidationFailure('From date cannot be after to date');
    }

    return NewsParams(
      company: company,
      country: country,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  /// Creates NewsParams for yesterday to now
  factory NewsParams.yesterdayToNow({
    required String company,
    required String country,
  }) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return NewsParams.create(
      company: company,
      country: country,
      fromDate: yesterday,
      toDate: now,
    );
  }

  Map<String, String> toMap() {
    return {
      'q': company,
      'from': fromDate.toIso8601String().split('T')[0],
      'to': toDate.toIso8601String().split('T')[0],
      'sortBy': "publishedAt",
      'country': country,
    };
  }

  @override
  String toString() =>
      'NewsParams(company: $company, from: $fromDate, to: $toDate)';
}
