import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:swirl_news_app/core/network/network_info.dart';
import 'package:swirl_news_app/features/news/data/datasources/remote/news_remote_datasource.dart';
import 'package:swirl_news_app/features/news/data/repositories/news_repository_impl.dart';
import 'package:swirl_news_app/features/news/domain/repositories/news_repository.dart';
import 'package:swirl_news_app/features/news/domain/usecases/get_top_headlines.dart';
import 'package:swirl_news_app/features/news/presentation/bloc/news_bloc.dart';

final sl = GetIt.instance;

Future<void> init(String apiKey) async {
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl(), apiKey),
  );

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerFactory(() => NewsBloc(sl()));
}
