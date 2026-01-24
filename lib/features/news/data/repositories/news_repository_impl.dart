import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/news_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/remote/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, List<NewsEntity>>> getTopHeadlines(
      int page, int pageSize) async {
    if (await networkInfo.isConnected) {
      try {
        final result =
            await remoteDataSource.getTopHeadlines(page, pageSize);
        return Right(result);
      } catch (e) {
        return const Left(ServerFailure('Server error'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
