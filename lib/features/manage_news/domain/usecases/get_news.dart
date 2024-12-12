import 'package:news_app/features/manage_news/domain/repository/news_repository.dart';

import '../entities/news_entity.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<List<NewsEntity>> call({
    required String query,
    String? category,
    String? language,
    String? country,
  }) {
    return repository.fetchNews(
      query: query,
      category: category,
      language: language,
      country: country,
    );
  }
}
