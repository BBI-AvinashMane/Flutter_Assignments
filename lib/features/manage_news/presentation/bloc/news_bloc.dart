import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/manage_news/domain/entities/news_entity.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_event.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_state.dart';
import '../../domain/usecases/get_news.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;

  NewsBloc(this.getNews) : super(NewsInitial()) {
    on<LoadNewsEvent>(_onLoadNews);
    on<RefreshNewsEvent>(_onRefreshNews);
  }

  Future<void> _onLoadNews(LoadNewsEvent event, Emitter<NewsState> emit) async {
    print(" yeaah ${event.page} -${event.language} -${event.query}");
    final currentState = state;
    List<NewsEntity> oldNews = [];
    bool hasMoreData = true;

    if (currentState is NewsLoaded && event.page > 1) {
      oldNews = currentState.news;
    }

    try {
       print(" yeaah ${event.page} -${event.language} -${event.query}");
       
      final news = await getNews(
        query: event.query,
        language: event.language.toString(),
        page: event.page,
        pageSize: event.pageSize,
      );

      // print("response in bloc $news");
      hasMoreData = news.length >= event.pageSize;

      emit(NewsLoaded(
        news: [...oldNews, ...news],
        hasMoreData: hasMoreData,
      ));
    } catch (error) {
      print(error);
      print("samual");
      emit(NewsError(message: 'Failed to fetch news: $error'));
    }
  }

  Future<void> _onRefreshNews(
      RefreshNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading(isRefreshing: true));

    try {
      final news = await getNews(
        query: event.query,
        language: event.language.toString(),
        page: 1,
        pageSize: event.pageSize,
      );

      emit(NewsLoaded(
        news: news,
        hasMoreData: news.length >= event.pageSize,
      ));
    } catch (error) {
      emit(NewsError(message: 'Failed to refresh news: $error'));
    }
  }
}
