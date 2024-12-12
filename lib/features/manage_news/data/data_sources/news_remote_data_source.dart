import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> fetchNews({
    required String query,
    String? category,
    String? language,
    String? country,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final String _baseUrl = 'https://newsapi.org/v2/everything';
  // final String _baseUrl =  'https://newsapi.org/v2/top-headlines/sources';
  final String? _apiKey = dotenv.env['API_KEY'];

Future<List<NewsModel>> fetchNews({
    required String query,
    String? category,
    String? language,
    String? country,
  }) async {
    final Uri url = Uri.parse(
      '$_baseUrl?q=${Uri.encodeQueryComponent(query.isEmpty ? "cricket" : query)}'
      '${category != null && category.isNotEmpty ? "&category=$category" : ""}'
      '${language != null && language.isNotEmpty ? "&language=$language" : ""}'
      '${country != null && country.isNotEmpty ? "&country=$country" : ""}'
      '&apiKey=$_apiKey',
    );

    print('Requesting URI: $url');

    try {
      final response = await http.get(url);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
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
    // try {
    //   final response = await http.get(url);

    //   print('Response body: ${response.body}');

    //   if (response.statusCode == 200) {
    //     final Map<String, dynamic> data = json.decode(response.body);

    //     if (data['sources'] != null) {
    //       return (data['sources'] as List)
    //           .map((source) => NewsModel.fromJson(source))
    //           .toList();
    //     } else {
    //       throw Exception('No sources found in response');
    //     }
    //   } else {
    //     throw Exception(
    //         'Failed to fetch news. Status code: ${response.statusCode}, Message: ${response.body}');
    //   }
    // } catch (error) {
    //   throw Exception('Failed to fetch news: $error');
    // }
  }
}

