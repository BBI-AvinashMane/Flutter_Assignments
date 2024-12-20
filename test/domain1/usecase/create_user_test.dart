import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/manage_news/domain/entities/news_entity.dart';
import 'package:news_app/features/manage_news/domain/repository/news_repository.dart';
import 'package:news_app/features/manage_news/domain/usecases/get_news.dart';

class MockUsecasePage extends Mock implements NewsRepository {}

void main() {

  late GetNews getNews;
  late NewsRepository newsrepo;

  setUp(() {
    newsrepo = MockUsecasePage();
    getNews = GetNews(newsrepo);
  });

  test("should call getnews usecase", () async {
            //arrange
             List<NewsEntity> articles = [
                const NewsEntity(title: 'News 1', description: 'Description 1', imageUrl: ''),
                const NewsEntity(title: 'News 2', description: 'Description 2', imageUrl: ''),
              ];

            when(() => newsrepo.fetchNews(
                query: any(named: 'query'),
                language: any(named: 'language'),
                page: any(named: 'page'),
                pageSize: any(named: 'pageSize'))
                ).thenAnswer((_)async=> articles);

            //act  
              final result=  await getNews.call(query: 'flutter', language: 'en', page: 3, pageSize: 20);

            //assert
            expect(result,articles);
    });
}
