import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/core/theme/theme_manager.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_state.dart';
import 'package:news_app/features/manage_news/presentation/pages/news_page.dart';

import '../widget/news_page_test.dart';


void main() {
  late MockNewsBloc mockNewsBloc;
  late ThemeManager themeManager;

  setUp(() {
    mockNewsBloc = MockNewsBloc();
    themeManager = ThemeManager(ThemeData.light());
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      theme: themeManager.value,
      home: BlocProvider.value(
        value: mockNewsBloc,
        child: NewsPage(themeManager: themeManager),
      ),
    );
  }

  testWidgets('displays "No news available" when NewsLoaded is empty', (tester) async {
    when(() => mockNewsBloc.state).thenReturn(const NewsLoaded(news: [], hasMoreData: false));
    await tester.pumpWidget(buildTestableWidget());
    expect(find.text('No news available'), findsOneWidget);
  });
  
}
