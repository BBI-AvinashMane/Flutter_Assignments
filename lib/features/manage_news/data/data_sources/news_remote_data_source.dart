// features/news/data/data_sources/news_remote_data_source.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/core/network/api_client.dart';
import 'package:news_app/features/manage_news/data/model/news_model.dart';
class NewsRemoteDataSource {
  // final ApiClient apiClient;
  final String? api_key=dotenv.env['API_KEY'];

  // NewsRemoteDataSource(this.apiClient);

  Future<List<NewsModel>> fetchNews() async {
    final response = await http.get(
      Uri.parse("https://newsapi.org/v2/everything?q=bitcoin&apiKey=$api_key" ),
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
