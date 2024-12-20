import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_event.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_state.dart';
import '../../../../test_helper.dart';
import '../helpers/fake_classes.dart';

void main() {
  late NewsBloc newsBloc;
  late MockGetNews mockGetNews;

  setUp(() {
    mockGetNews = MockGetNews();
    newsBloc = NewsBloc(mockGetNews);
  });

  blocTest<NewsBloc, NewsState>(
    'emits [NewsLoading, NewsLoaded] when LoadNewsEvent is added',
    build: () {
      // Arrange: Mock the GetNews use case to return an empty list
      when(() => mockGetNews.call(
            query: 'Flutter',
            language: 'en',
            page: 1,
            pageSize: 20,
          )).thenAnswer((_) async => []);
      return newsBloc;
    },
    act: (bloc) => bloc.add(const LoadNewsEvent(
      query: 'Flutter',
      language: 'en',
      page: 1,
      pageSize: 20,
    )),
    expect: () => [isA<NewsLoading>(), isA<NewsLoaded>()],
  );

  blocTest<NewsBloc, NewsState>(
    'emits [NewsLoading, NewsError] when an error occurs',
    build: () {
      // Arrange: Mock the GetNews use case to throw an exception
      when(() => mockGetNews.call(
            query: 'Flutter',
            language: 'en',
            page: 1,
            pageSize: 20,
          )).thenThrow(Exception('Failed to load'));
      return newsBloc;
    },
    act: (bloc) => bloc.add(const LoadNewsEvent(
      query: 'Flutter',
      language: 'en',
      page: 1,
      pageSize: 20,
    )),
    expect: () => [isA<NewsLoading>(), isA<NewsError>()],
  );
}
