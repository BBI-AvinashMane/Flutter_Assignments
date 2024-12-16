import 'package:flutter/material.dart';
import '../../domain/entities/news_entity.dart';

class NewsCard extends StatefulWidget {
  final NewsEntity article;

  const NewsCard({Key? key, required this.article}) : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool _isExpanded = false;
 

  @override
  Widget build(BuildContext context) {
   
    final theme = Theme.of(context);
    final seeMoreColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.secondary 
        : theme.primaryColor;        

    if (widget.article.title == "[Removed]" &&
        widget.article.description == "[Removed]") {
      return Container();
    }
    return Card(
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
              widget.article.title,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            widget.article.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.article.imageUrl,
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
              widget.article.description,
              maxLines: _isExpanded ? null : 3,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded; 
                });
              },
              child: Text(
                _isExpanded ? "See Less" : "See More",
                style: TextStyle(
                  color: seeMoreColor, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
