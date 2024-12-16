import 'package:flutter/material.dart';
import 'news_card.dart';
import '../../domain/entities/news_entity.dart';

class NewsList extends StatelessWidget {
  final List<NewsEntity> news;
  final ScrollController scrollController;
  final bool hasMoreData;

  const NewsList({
    Key? key,
    required this.news,
    required this.scrollController,
    required this.hasMoreData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: news.length + (hasMoreData ? 1 : 0), // Include loader if needed
      itemBuilder: (context, index) {
        if (index < news.length) {
          return NewsCard(article: news[index]);
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
