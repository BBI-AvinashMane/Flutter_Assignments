import 'package:flutter/material.dart';
import '../../domain/entities/news_entity.dart';

class NewsCard extends StatelessWidget {
  final NewsEntity article;

  const NewsCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (article.title == "[Removed]" && article.description == "[Removed]") {
      return Container(); // Skip removed articles
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: article.imageUrl.isNotEmpty
            ? Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                width: 60,
              )
            : const Icon(Icons.image_not_supported),
        title: Text(article.title),
        subtitle: Text(
          article.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
