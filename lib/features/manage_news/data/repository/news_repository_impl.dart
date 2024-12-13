// import '../data_sources/news_remote_data_source.dart';
// import '../../domain/entities/news_entity.dart';
// import '../../domain/repository/news_repository.dart';

// class NewsRepositoryImpl implements NewsRepository {
//   final NewsRemoteDataSource remoteDataSource;

//   NewsRepositoryImpl( this.remoteDataSource);

//   @override
//   Future<List<NewsEntity>> fetchNews({
//     required String query,
//     String? language,
//     required int page,
//     required int pageSize,
//   }) async {
//     // Fetch news from the remote data source
//     final newsModels = await remoteDataSource.fetchNews(
//       query: query,
//       language: language,
//       page: page,
//       pageSize: pageSize,
//     );

//     // Convert news models to entities
//     return newsModels.map((model) => model.toEntity()).toList();
//   }
// }
import '../data_sources/news_remote_data_source.dart';
import '../../domain/entities/news_entity.dart';
import '../../domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NewsEntity>> fetchNews({
    required String query,
    required String language,
    required int page,
    required int pageSize,
  }) async {
    final newsModels = await remoteDataSource.fetchNews(
      query: query,
      language: language,
      page: page,
      pageSize: pageSize,
    );

    return newsModels.map((model) => model.toEntity()).toList();
  }
}
