import '../../domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required String title,
    required String description,
    required String imageUrl,
  }) : super(
          title: title,
          description: description,
          imageUrl: imageUrl,
        );

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['urlToImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  NewsEntity toEntity() {
    return NewsEntity(
      title: title,
      description: description,
      imageUrl: imageUrl,
    );
  }
}
