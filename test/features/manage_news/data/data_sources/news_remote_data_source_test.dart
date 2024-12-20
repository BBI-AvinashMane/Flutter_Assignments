import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/manage_news/data/data_sources/news_remote_data_source.dart';
import 'package:news_app/features/manage_news/data/model/news_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late NewsRemoteDataSourceImpl remoteDataSource;
  late MockHttpClient mockHttpClient;

  const String baseUrl = 'https://newsapi.org/v2/everything';
  const String apiKey = 'testApiKey'; // Simulated API key

  const String query = 'flutter';
  const String language = 'en';
  const int page = 1;
  const int pageSize = 10;

  setUpAll(() {
    // Register a fallback value for Uri
    registerFallbackValue(FakeUri());
  });

  setUp(() async {
    // Initialize dotenv to load environment variables
    await dotenv.load();

    // Set the API key for testing
    dotenv.env['API_KEY'] = apiKey;

    // Initialize the mock HTTP client and the remote data source
    mockHttpClient = MockHttpClient();
    remoteDataSource = NewsRemoteDataSourceImpl(mockHttpClient);
  });

  group('fetchNews', () {
    test('should return a list of NewsModel when the response is successful', () async {
      // Arrange: Simulate a successful API response
      final mockResponse = {
        'status': 'ok',
        'totalResults': 2,
        'articles': [
          {
            'title': 'Flutter 3 Released',
            'description': 'The latest version of Flutter has been released.',
            'url': 'https://example.com/flutter-3',
            'urlToImage': 'https://example.com/flutter.jpg',
            'publishedAt': '2021-01-01T12:00:00Z',
          },
          {
            'title': 'Dart 2.13 Released',
            'description': 'Dart 2.13 is now available with new features.',
            'url': 'https://example.com/dart-2.13',
            'urlToImage': 'https://example.com/dart.jpg',
            'publishedAt': '2021-01-02T15:00:00Z',
          },
        ],
      };

      // Mock the behavior of the HTTP client to return a successful response
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      // Act: Call fetchNews method with mock parameters
      final result = await remoteDataSource.fetchNews(
        query: query,
        language: language,
        page: page,
        pageSize: pageSize,
      );

      // Assert: Check the result matches expected data
      expect(result, isA<List<NewsModel>>());
      expect(result.length, 2);
      expect(result[0].title, 'Flutter 3 Released');
      expect(result[1].title, 'Dart 2.13 Released');

      // Verify that http.get was called with the correct URL
      verify(() => mockHttpClient.get(
        Uri.parse(
          '$baseUrl?q=${Uri.encodeQueryComponent(query)}&language=$language&page=$page&pageSize=$pageSize&apiKey=$apiKey',
        ),
      )).called(1);
    });

    test('should throw an exception when the response status code is not 200', () async {
      // Arrange: Simulate a failed API response
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response('Internal Server Error', 500),
      );

      // Act & Assert: Expect an exception to be thrown
      expect(
        () async => await remoteDataSource.fetchNews(
          query: query,
          language: language,
          page: page,
          pageSize: pageSize,
        ),
        throwsA(isA<Exception>()),
      );

      // Verify that http.get was called with the correct URL
      verify(() => mockHttpClient.get(any())).called(1);
    });
  });
}
