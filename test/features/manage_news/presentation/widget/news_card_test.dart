import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/manage_news/presentation/pages/news_card.dart';


void main() {
  testWidgets('renders NewsCard widget with data', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewsCard(
          title: 'Test News',
          description: 'Test Description',
          imageUrl: 'https://via.placeholder.com/150',
        ),
      ),
    );
    expect(find.text('Test News'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
