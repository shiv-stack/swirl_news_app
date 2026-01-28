import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/news_entity.dart';
import '../pages/news_detail_page.dart';

class NewsFullWidthCard extends StatelessWidget {
  final NewsEntity article;

  const NewsFullWidthCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailPage(article: article),
            ),
          );
        },
        child: Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Image(
                imageUrl: article.imageUrl,
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: _TextContent(article: article),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// IMAGE
class _Image extends StatelessWidget {
  final String imageUrl;
  final double height;

  const _Image({
    required this.imageUrl,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported, size: 40),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        height: height,
        color: Colors.grey.shade200,
      ),
      errorWidget: (_, __, ___) => Container(
        height: height,
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image),
      ),
    );
  }
}

/// TEXT
class _TextContent extends StatelessWidget {
  final NewsEntity article;

  const _TextContent({required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (article.description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            article.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 8),
        Text(
          article.source,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
