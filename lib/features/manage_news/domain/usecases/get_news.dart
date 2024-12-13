import '../../domain/entities/news_entity.dart';
import '../../domain/repository/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<List<NewsEntity>> call({
    required String query,
    required String language,
    int page = 1,
    int pageSize = 20,
  }) async {
    return repository.fetchNews(
      query: query,
      language: language,
      page: page,
      pageSize: pageSize,
    );
  }
}

