import 'package:equatable/equatable.dart';
import '../../domain/entities/news_entity.dart';

abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> articles;
  final bool hasReachedMax;

  NewsLoaded(this.articles, this.hasReachedMax);

  @override
  List<Object?> get props => [articles, hasReachedMax];
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}
