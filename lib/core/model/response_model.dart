class ResponseModel<B> {
  final String status;
  final num totalResults;
  final B? articles;

  ResponseModel(this.status, this.totalResults, this.articles);

  ResponseModel.fromJsonObject(Map<String, dynamic> json, {B Function(Map<String, dynamic> bodyJson)? bodyBuilder})
    : status = json["status"],
      totalResults = json["totalResults"],
      articles = json["articles"] != null ? bodyBuilder?.call(json["articles"]) : null;

  ResponseModel.fromJsonArray(Map<String, dynamic> json, {B Function(List<dynamic>)? bodyBuilder})
    : status = json["status"],
      totalResults = json["totalResults"],
      articles = json["articles"] != null ? bodyBuilder?.call(json["articles"]) : null;
}
