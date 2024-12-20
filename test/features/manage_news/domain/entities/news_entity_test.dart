import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/manage_news/domain/entities/news_entity.dart';

void main() {
  test('NewsEntity should have correct properties', () {
    const news = NewsEntity(title: 'Test News', description: 'Description', imageUrl: '');
    expect(news.title, 'Test News');
    expect(news.description, 'Description');
    expect(news.imageUrl, '');
  });
}
