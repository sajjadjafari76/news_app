import 'package:hive/hive.dart';
import 'package:interview/feature/news/domain/entities/news_entities.dart';

part 'news_model.g.dart';

@HiveType(typeId: 0)
class NewsModel {
  const NewsModel({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  @HiveField(0)
  final String? author;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? url;

  @HiveField(4)
  final String? urlToImage;

  @HiveField(5)
  final DateTime? publishedAt;

  @HiveField(6)
  final String? content;

  NewsModel copyWith({
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? content,
  }) {
    return NewsModel(
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      author: json["author"],
      title: json["title"],
      description: json["description"],
      url: json["url"],
      urlToImage: json["urlToImage"],
      publishedAt: DateTime.tryParse(json["publishedAt"] ?? ""),
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() => {
    "author": author,
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": publishedAt?.toIso8601String(),
    "content": content,
  };

  @override
  String toString() {
    return "$author, $title, $description, $url, $urlToImage, $publishedAt, $content, ";
  }

  /// Convert Model → Entity
  NewsEntity toEntity() {
    return NewsEntity(
      title: title,
      author: author,
      description: description,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
    );
  }

  factory NewsModel.fromEntity(NewsEntity entity) {
    return NewsModel(
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
    );
  }
}
