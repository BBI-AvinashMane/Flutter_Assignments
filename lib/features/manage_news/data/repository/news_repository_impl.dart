import '../../domain/repository/news_repository.dart';
import '../../domain/entities/news_entity.dart';
import '../data_sources/news_remote_data_source.dart';
import '../model/news_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NewsEntity>> fetchNews({
    required String query,
    String? category,
    String? language,
    String? country,
  }) async {
    // Fetch data from the remote data source
    final List<NewsModel> newsModels = await remoteDataSource.fetchNews(
      query: query,
      category: category,
      language: language,
      country: country,
    );

    // Convert NewsModel to NewsEntity
    return newsModels.map((model) => model.toEntity()).toList();
  }
}
