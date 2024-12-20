import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/features/manage_news/domain/entities/news_entity.dart';
import 'package:news_app/features/manage_news/presentation/pages/news_list.dart';

void main() {
  testWidgets('renders list of news articles', (WidgetTester tester) async {
    final articles = [
      const NewsEntity(title: 'News 1', description: 'Description 1', imageUrl: ''),
      const NewsEntity(title: 'News 2', description: 'Description 2', imageUrl: ''),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: NewsList(news: articles, hasMoreData: false),
      ),
    );

    expect(find.text('News 1'), findsOneWidget);
    expect(find.text('News 2'), findsOneWidget);
  });
}
