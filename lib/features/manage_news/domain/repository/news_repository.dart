import '../entities/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> fetchNews({
    required String query,
    String? category,
    String? language,
    String? country,
  });
}
