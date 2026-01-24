import '../../domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.content,
    required super.source,
    required super.url,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      content: json['content'] ?? '',
      source: json['source']['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
