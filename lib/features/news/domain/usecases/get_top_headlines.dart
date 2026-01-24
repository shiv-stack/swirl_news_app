import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/news_entity.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines
    implements UseCase<List<NewsEntity>, GetTopHeadlinesParams> {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(
      GetTopHeadlinesParams params) {
    return repository.getTopHeadlines(params.page, params.pageSize);
  }
}

class GetTopHeadlinesParams {
  final int page;
  final int pageSize;

  GetTopHeadlinesParams({required this.page, required this.pageSize});
}
