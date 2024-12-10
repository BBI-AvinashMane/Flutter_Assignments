// features/news/presentation/bloc/news_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_news.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;

  NewsBloc(this.getNews) : super(NewsInitial()) {
    on<LoadNewsEvent>(_onLoadNews);
  }

  Future<void> _onLoadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final news = await getNews();
      emit(NewsLoaded(news: news));
    } catch (e) {
      emit(NewsError(message: 'Failed to load news: ${e.toString()}'));
    }
  }
}
