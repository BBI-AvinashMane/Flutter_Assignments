import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/manage_news/domain/repository/news_repository.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository mockNewsRepository;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
  });

  group('NewsRepository', () {
    test('should fetch news successfully with correct arguments', () async {
      // Arrange: Mock the fetchNews method to return an empty list
      when(() => mockNewsRepository.fetchNews(
            query: 'Flutter',
            language: 'en',
            page: 1,
            pageSize: 20,
          )).thenAnswer((_) async => []);

      // Act: Call the fetchNews method
      final result = await mockNewsRepository.fetchNews(
        query: 'Flutter',
        language: 'en',
        page: 1,
        pageSize: 20,
      );

      // Assert: Verify the result and interaction
      expect(result, []);
      verify(() => mockNewsRepository.fetchNews(
            query: 'Flutter',
            language: 'en',
            page: 1,
            pageSize: 20,
          )).called(1);
    });
  });
}
