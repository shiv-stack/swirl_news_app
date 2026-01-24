import 'package:flutter/material.dart';
import '../../domain/entities/news_entity.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntity article;
  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.source)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (article.imageUrl.isNotEmpty)
              Image.network(article.imageUrl),
            const SizedBox(height: 16),
            Text(article.title,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(article.content),
          ],
        ),
      ),
    );
  }
}
