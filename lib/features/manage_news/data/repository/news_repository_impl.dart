// features/news/data/repositories/news_repository_impl.dart

import 'package:news_app/features/manage_news/domain/repository/news_repository.dart';

import '../../domain/entities/news_entity.dart';
import '../data_sources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NewsEntity>> getNews() async {
    final newsModels = await remoteDataSource.fetchNews();
    return newsModels.map((model) => NewsEntity(
      title: model.title,
      description: model.description,
      imageUrl: model.imageUrl,
    )).toList();
  }
}
