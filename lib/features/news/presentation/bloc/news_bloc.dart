import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_top_headlines.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;
  int page = 1;
  final int pageSize = 22;
  bool isFetching = false;

  NewsBloc(this.getTopHeadlines) : super(NewsInitial()) {
    on<FetchNewsEvent>(_onFetchNews);
  }

  Future<void> _onFetchNews(
      FetchNewsEvent event, Emitter<NewsState> emit) async {
    if (isFetching) return;
    isFetching = true;

    if (state is NewsInitial) {
      emit(NewsLoading());
    }

    final result = await getTopHeadlines(
      GetTopHeadlinesParams(page: page, pageSize: pageSize),
    );

    result.fold(
      (failure) => emit(NewsError(failure.message)),
      (articles) {
        page++;
        final current =
            state is NewsLoaded ? (state as NewsLoaded).articles : [];
        emit(NewsLoaded(
            [...current, ...articles], articles.isEmpty));
      },
    );

    isFetching = false;
  }
}
