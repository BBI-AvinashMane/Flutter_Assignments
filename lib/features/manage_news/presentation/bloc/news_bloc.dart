import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_news.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;

  NewsBloc({required this.getNews}) : super(NewsInitial()) {
    on<LoadNewsEvent>(_onLoadNews);
  }

  Future<void> _onLoadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final news = await getNews(
        query: event.query ?? "cricket", // Default to "latest"
        category: event.category,
        language: event.language,
        country: event.country,
      );
      emit(NewsLoaded(news: news));
    } catch (e) {
      emit(NewsError(message: 'Failed to load news: ${e.toString()}'));
    }
  }
}
