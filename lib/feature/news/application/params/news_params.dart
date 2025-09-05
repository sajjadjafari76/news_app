class NewsParams {
  final String? country;
  final String q;
  final int page;
  final int pageSize;

  NewsParams({required this.q, this.country, required this.page, required this.pageSize});

  Map<String, String> toMap() {
    final map = {
      'q': q,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    if (country != null) {
      map['country'] = country!;
    }
    return map;
  }
}
