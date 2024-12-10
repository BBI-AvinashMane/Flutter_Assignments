// features/news/domain/usecases/get_news.dart
import 'package:news_app/features/manage_news/domain/repository/news_repository.dart';

import '../entities/news_entity.dart';


class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<List<NewsEntity>> call() async {
    return await repository.getNews();
  }
}
