import '../entities/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> fetchNews({
    required String query,
    required String language,
    required int page,
    required int pageSize,
  });
}
