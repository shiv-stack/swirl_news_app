import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swirl_news_app/features/news/domain/entities/news_entity.dart';
import 'package:swirl_news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:swirl_news_app/features/news/presentation/bloc/news_event.dart';
import 'package:swirl_news_app/features/news/presentation/bloc/news_state.dart';
import 'package:swirl_news_app/features/news/presentation/widgets/news_full_width_card.dart';
import 'package:swirl_news_app/features/news/presentation/widgets/news_grid_card.dart';

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
    final state = context.read<NewsBloc>().state;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        state is NewsLoaded &&
        !state.hasReachedMax) {
      context.read<NewsBloc>().add(FetchNewsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Headlines'), centerTitle: true),
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
                ..._buildSlivers(state.articles),

                if (!state.hasReachedMax)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
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

  /// 🔥 CORE UI LOGIC (FIXED)
  List<Widget> _buildSlivers(List<NewsEntity> articles) {
    final List<Widget> slivers = [];
    final List<NewsEntity> gridBuffer = [];

    for (int i = 0; i < articles.length; i++) {
      final article = articles[i];

      // Every 7th article → full width
      if (i % 7 == 0) {
        if (gridBuffer.isNotEmpty) {
          slivers.add(_buildGridSliver(gridBuffer));
          gridBuffer.clear();
        }

        slivers.add(
          SliverToBoxAdapter(child: NewsFullWidthCard(article: article)),
        );
      } else {
        gridBuffer.add(article);
      }
    }

    if (gridBuffer.isNotEmpty) {
      slivers.add(_buildGridSliver(gridBuffer));
    }

    return slivers;
  }

  Widget _buildGridSliver(List<NewsEntity> articles) {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return NewsGridCard(article: articles[index]);
        }, childCount: articles.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
      ),
    );
  }
}
