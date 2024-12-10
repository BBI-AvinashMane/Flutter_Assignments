// features/news/data/models/news_model.dart

class NewsModel {
  final String title;
  final String description;
  final String imageUrl;

  NewsModel({required this.title, required this.description, required this.imageUrl});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
    );
  }
}
