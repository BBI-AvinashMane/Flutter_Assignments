import 'package:equatable/equatable.dart';
import '../../domain/entities/news_entity.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {
  final bool isLazy;
  final bool isRefreshing;

  const NewsLoading({this.isLazy = false, this.isRefreshing = false});

  @override
  List<Object?> get props => [isLazy, isRefreshing];
}

class NewsLoaded extends NewsState {
  final List<NewsEntity> news;
  final bool hasMoreData;

  const NewsLoaded({required this.news, required this.hasMoreData});

  @override
  List<Object?> get props => [news, hasMoreData];
}

class NewsError extends NewsState {
  final String message;

  const NewsError({required this.message});

  @override
  List<Object?> get props => [message];
}
