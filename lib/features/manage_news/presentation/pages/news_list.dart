// import 'package:flutter/material.dart';
// import '../../domain/entities/news_entity.dart';
// import 'news_card.dart';

// class NewsList extends StatelessWidget {
//   final List<NewsEntity> news;
//   final ScrollController scrollController;
//   final bool hasMoreData;

//   const NewsList({
//     Key? key,
//     required this.news,
//     required this.scrollController,
//     required this.hasMoreData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       controller: scrollController,
//       itemCount: news.length + (hasMoreData ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index < news.length) {
//           return NewsCard(article: news[index]);
//         } else {
//           return const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//       },
//     );
//   }
// }
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

        return GestureDetector(
          onTap: () {
            // Add a feature to view full article or details
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  article.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            article.imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 8),
                  Text(
                    article.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
