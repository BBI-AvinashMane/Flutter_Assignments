// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import '../model/news_model.dart';

// abstract class NewsRemoteDataSource {
//   Future<List<NewsModel>> fetchNews({
//     required String query,
//     String? language,
//     required int page,
//     required int pageSize,
//   });
// }

// class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  
//   final String _baseUrl = 'https://newsapi.org/v2/everything';
//   final String? _apiKey = dotenv.env['API_KEY'];

//   @override
//   Future<List<NewsModel>> fetchNews({
//     required String query,
//     String? language,
//     required int page,
//     required int pageSize
//   }) async {
//     final Uri url = Uri.parse(
//       '$_baseUrl?q=${Uri.encodeQueryComponent(query.isEmpty ? "latest" : query)}'
//       '${language != null && language.isNotEmpty ? "&language=$language" : ""}'
//       '&page=$page&pageSize=$pageSize&apiKey=$_apiKey',
//     );

//     print('Requesting URI: $url');

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         final List<dynamic> articlesJson = data['articles'];

//         return articlesJson
//             .map((articleJson) => NewsModel.fromJson(articleJson))
//             .toList();
//       } else {
//         throw Exception(
//             'Failed to fetch news. Status code: ${response.statusCode}, Message: ${response.body}');
//       }
//     } catch (error) {
//       throw Exception('Failed to fetch news: $error');
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> fetchNews({
    required String query,
    required String language,
    required int page,
    required int pageSize,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final String _baseUrl = 'https://newsapi.org/v2/everything';
  final String? _apiKey = dotenv.env['API_KEY'];

  @override
  Future<List<NewsModel>> fetchNews({
    required String query,
    required String language,
    required int page,
    required int pageSize,
  }) async {

    print('$_baseUrl?q=${Uri.encodeQueryComponent(query.isEmpty ? "latest" : query)}'
      '${language.isNotEmpty ? "&language=$language" : ""}'
      '&page=$page&pageSize=$pageSize&apiKey=$_apiKey');
      
    final Uri url = Uri.parse(
      '$_baseUrl?q=${Uri.encodeQueryComponent(query.isEmpty ? "latest" : query)}'
      '${language.isNotEmpty ? "&language=$language" : ""}'
      '&page=$page&pageSize=$pageSize&apiKey=$_apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];

        return articlesJson
            .map((articleJson) => NewsModel.fromJson(articleJson))
            .toList();
      } else {
        throw Exception(
            'Failed to fetch news. Status code: ${response.statusCode}, Message: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to fetch news: $error');
    }
  }
}
