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
    final currentState = state;
    List<NewsEntity> oldNews = [];
    bool hasMoreData = true;

    if (currentState is NewsLoaded && event.page > 1) {
      oldNews = currentState.news;
    }

    try { 
      final news = await getNews(
        query: event.query,
        language: event.language.toString(),
        page: event.page,
        pageSize: event.pageSize,
      );
         hasMoreData = news.length >= event.pageSize;
      if (news.isEmpty) {
        if (event.page == 1) {
          // No data even on the first page
          emit(NewsError(message: 'No news available on this topic.'));
        } else {
          // No more data on subsequent pages
          hasMoreData = false;
          emit(NewsLoaded(news: oldNews, hasMoreData: hasMoreData));
        }
      } else {
        emit(NewsLoaded(news: [...oldNews, ...news], hasMoreData: hasMoreData));
      }
    } catch (error) {
      emit(NewsError(message: 'Failed to fetch news: $error'));
    }
  }



  //     emit(NewsLoaded(
  //       news: [...oldNews, ...news],
  //       hasMoreData: hasMoreData,
  //     ));
  //   } catch (error) {
  //     print(error);
  //     emit(NewsError(message: 'Failed to fetch news: $error'));
  //   }
  // }

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
        hasMoreData: news.length == event.pageSize,
      ));
    } catch (error) {
      emit(NewsError(message: 'Failed to refresh news: $error'));
    }
  }
}
