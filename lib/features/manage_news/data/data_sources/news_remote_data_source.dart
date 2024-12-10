// features/news/data/data_sources/news_remote_data_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/core/network/api_client.dart';
import 'package:news_app/features/manage_news/data/model/news_model.dart';
class NewsRemoteDataSource {
  // final ApiClient apiClient;

  // NewsRemoteDataSource(this.apiClient);

  Future<List<NewsModel>> fetchNews() async {
    final response = await http.get(
      Uri.parse("https://newsapi.org/v2/everything?q=bitcoin&apiKey=737009333b3e41e9a3d96c330545b6e9" ),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return (data['articles'] as List)
          .map((article) => NewsModel.fromJson(article))
          .toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
