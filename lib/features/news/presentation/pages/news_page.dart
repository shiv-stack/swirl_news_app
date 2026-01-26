import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../../domain/entities/news_entity.dart';
import 'news_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<NewsBloc>().add(FetchNewsEvent());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<NewsBloc>().add(FetchNewsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isFullWidth(int index) {
    // Every 1st item of a group of 7 is full width
    return index % 7 == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        centerTitle: true,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NewsError) {
            return Center(child: Text(state.message));
          }

          if (state is NewsLoaded) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final article = state.articles[index];

                        if (_isFullWidth(index)) {
                          return _FullWidthNewsCard(article: article);
                        }

                        // Two-column grid row logic
                        final secondIndex = index + 1;

                        if (secondIndex >= state.articles.length ||
                            _isFullWidth(secondIndex)) {
                          return _HalfWidthRow(
                            left: article,
                            right: null,
                          );
                        }

                        return _HalfWidthRow(
                          left: article,
                          right: state.articles[secondIndex],
                        );
                      },
                      childCount: state.articles.length,
                    ),
                  ),
                ),
                if (!state.hasReachedMax)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}


/// UI COMPONENTS


class _FullWidthNewsCard extends StatelessWidget {
  final NewsEntity article;

  const _FullWidthNewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Image(imageUrl: article.imageUrl, height: 200),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _TextContent(article: article),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsDetailPage(article: article),
      ),
    );
  }
}

class _HalfWidthRow extends StatelessWidget {
  final NewsEntity left;
  final NewsEntity? right;

  const _HalfWidthRow({required this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _HalfWidthNewsCard(article: left)),
        const SizedBox(width: 8),
        Expanded(
          child: right != null
              ? _HalfWidthNewsCard(article: right!)
              : const SizedBox(),
        ),
      ],
    );
  }
}

class _HalfWidthNewsCard extends StatelessWidget {
  final NewsEntity article;

  const _HalfWidthNewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Image(imageUrl: article.imageUrl, height: 120),
            Padding(
              padding: const EdgeInsets.all(8),
              child: _TextContent(
                article: article,
                isCompact: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsDetailPage(article: article),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String imageUrl;
  final double height;

  const _Image({required this.imageUrl, required this.height});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        height: height,
        color: Colors.grey.shade300,
        child: const Icon(Icons.image, size: 40),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          Container(height: height, color: Colors.grey.shade200),
      errorWidget: (_, __, ___) =>
          Container(height: height, color: Colors.grey.shade300),
    );
  }
}

class _TextContent extends StatelessWidget {
  final NewsEntity article;
  final bool isCompact;

  const _TextContent({
    required this.article,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          maxLines: isCompact ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (!isCompact) ...[
          const SizedBox(height: 8),
          Text(
            article.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 6),
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
