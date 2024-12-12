import 'package:flutter/material.dart';
import '../../domain/entities/news_entity.dart';

class NewsList extends StatelessWidget {
  final List<NewsEntity> news;

  const NewsList({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        final article = news[index];

        // Skip articles with "[Removed]" title or description
        if (article.title == "[Removed]" && article.description == "[Removed]") {
          return Container();
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display article title
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                // Display article image (with error handling for invalid URLs)
                article.imageUrl != null
                    ? SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          article.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        ),
                      )
                    : const SizedBox.shrink(),

                const SizedBox(height: 8),

                // Display article description
                Text(
                  article.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
