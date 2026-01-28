import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swirl_news_app/features/news/domain/entities/news_entity.dart';
import '../../domain/usecases/get_top_headlines.dart';
import 'news_event.dart';
import 'news_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;

  int page = 1;
  final int pageSize = 22;
  bool isFetching = false;

  NewsBloc(this.getTopHeadlines) : super(NewsInitial()) {
    on<FetchNewsEvent>(_onFetchNews,transformer: droppable(),);
  }

  Future<void> _onFetchNews(
    FetchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    if (isFetching) return;

    // Stop fetching if all data loaded
    if (state is NewsLoaded && (state as NewsLoaded).hasReachedMax) {
      return;
    }

    isFetching = true;

    final List<NewsEntity> currentArticles =
    state is NewsLoaded ? (state as NewsLoaded).articles : <NewsEntity>[];


    // Show loader only for first page
    if (page == 1) {
      emit(NewsLoading());
    }

    final result = await getTopHeadlines(
      GetTopHeadlinesParams(page: page, pageSize: pageSize),
    );

   result.fold(
      (failure) {
        emit(NewsLoaded(currentArticles, false));
      },
      (newArticles) {
        // 1. Increment page for the next request
        page++;

        // 2. Identify truly unique articles by comparing URLs
        // We filter 'newArticles' to only keep those not already in 'currentArticles'
        final uniqueNewArticles = newArticles.where((newArt) {
          return !currentArticles.any((existingArt) => existingArt.url == newArt.url);
        }).toList();

        final hasReachedMax = newArticles.length < pageSize;

        // 3. Merge the lists
        emit(NewsLoaded(
          [...currentArticles, ...uniqueNewArticles],
          hasReachedMax,
        ));
      },
    );

    isFetching = false;
  }
}
