// features/news/presentation/widgets/news_list.dart

import 'package:flutter/material.dart';
import '../../domain/entities/news_entity.dart';

class NewsList extends StatelessWidget {
  final List<NewsEntity> news;

  const NewsList({required this.news});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        final article = news[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.network(article.imageUrl, width: 50, fit: BoxFit.cover),
            title: Text(article.title),
            subtitle: Text(article.description),
          ),
        );
      },
    );
  }
}
