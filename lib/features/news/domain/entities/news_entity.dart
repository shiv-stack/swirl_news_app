import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String title;
  final String description;
  final String imageUrl;
  final String content;
  final String source;
  final String url;

  const NewsEntity({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.content,
    required this.source,
    required this.url,
  });

  @override
  List<Object?> get props => [title, url];
}
