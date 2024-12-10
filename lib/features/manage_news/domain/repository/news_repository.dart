// features/news/domain/repositories/news_repository.dart

import '../entities/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getNews();
}
