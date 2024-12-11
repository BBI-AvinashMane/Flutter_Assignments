// features/news/presentation/bloc/news_event.dart



import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNewsEvent extends NewsEvent {}
