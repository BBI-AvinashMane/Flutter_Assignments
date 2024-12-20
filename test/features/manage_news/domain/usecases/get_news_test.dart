import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/manage_news/domain/repository/news_repository.dart';
import 'package:news_app/features/manage_news/domain/usecases/get_news.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late GetNews getNews;
  late MockNewsRepository mockRepository;

  setUp(() {
    mockRepository = MockNewsRepository();
    getNews = GetNews(mockRepository);
  });

  test('fetches news articles from repository with correct arguments', () async {
    // Arrange: Mock the fetchNews method to return an empty list when called with specific arguments
    when(() => mockRepository.fetchNews(
          query: 'Flutter',
          language: 'en',
          page: 1,
          pageSize: 20,
        )).thenAnswer((_) async => []);

    // Act: Call the GetNews use case
    final result = await getNews(
      query: 'Flutter',
      language: 'en',
      page: 1,
      pageSize: 20,
    );

    // Assert: Verify the result and interaction
    expect(result, []);
    verify(() => mockRepository.fetchNews(
          query: 'Flutter',
          language: 'en',
          page: 1,
          pageSize: 20,
        )).called(1);
  });
}
