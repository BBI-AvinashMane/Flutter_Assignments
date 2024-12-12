import 'package:equatable/equatable.dart';
import '../../domain/entities/news_entity.dart';

abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> news;

  NewsLoaded({required this.news});

  @override
  List<Object?> get props => [news];
}

class NewsError extends NewsState {
  final String message;

  NewsError({required this.message});

  @override
  List<Object?> get props => [message];
}
