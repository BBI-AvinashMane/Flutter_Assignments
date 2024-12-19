// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:news_app/core/theme/theme_manager.dart';
// import 'package:news_app/features/manage_news/domain/entities/news_entity.dart';
// import 'package:news_app/features/manage_news/presentation/bloc/news_bloc.dart';
// import 'package:news_app/features/manage_news/presentation/bloc/news_event.dart';
// import 'package:news_app/features/manage_news/presentation/bloc/news_state.dart';
// import 'package:news_app/features/manage_news/presentation/pages/news_page.dart';

// class MockNewsBloc extends MockBloc<NewsEvent, NewsState> implements NewsBloc {}

// class FakeNewsEvent extends Fake implements NewsEvent {}

// class FakeNewsState extends Fake implements NewsState {}

// void main() {
//   group('NewsPage Widget Tests', () {
//     late MockNewsBloc mockNewsBloc;
//     late ThemeManager themeManager;

//     setUpAll(() {
//       registerFallbackValue(FakeNewsEvent());
//       registerFallbackValue(FakeNewsState());
//     });

//     setUp(() {
//       mockNewsBloc = MockNewsBloc();
//       themeManager = ThemeManager(ThemeData.light());
//     });

//     Widget buildTestableWidget() {
//       return MaterialApp(
//         home: Scaffold(
//           body: BlocProvider<NewsBloc>.value(
//             value: mockNewsBloc,
//             child: NewsPage(themeManager: themeManager),
//           ),
//         ),
//       );
//     }
 


//     testWidgets('should display "No news available" message',
//         (WidgetTester tester) async {
//       // Arrange
//       when(() => mockNewsBloc.state)
//           .thenReturn(const NewsLoaded(news: [], hasMoreData: false));

//       // Act
//       await tester.pumpWidget(buildTestableWidget());
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.text('No news available'), findsOneWidget);
//     });

//     testWidgets('should show CircularProgressIndicator while loading',
//         (WidgetTester tester) async {
//       // Arrange
//       when(() => mockNewsBloc.state).thenReturn(const NewsLoading());

//       // Act
//       await tester.pumpWidget(buildTestableWidget());
//       await tester.pump();

//       // Assert
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });

//     testWidgets('should show list of news articles when loaded',
//         (WidgetTester tester) async {
//       // Arrange
//       final articles = [
//         const NewsEntity(
//             title: 'News 1', description: 'Description 1', imageUrl: ''),
//         const NewsEntity(
//             title: 'News 2', description: 'Description 2', imageUrl: ''),
//       ];
//       when(() => mockNewsBloc.state)
//           .thenReturn(NewsLoaded(news: articles, hasMoreData: false));

//       // Act
//       await tester.pumpWidget(buildTestableWidget());
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.text('News 1'), findsOneWidget);
//       expect(find.text('News 2'), findsOneWidget);
//     });

//     testWidgets('should allow search functionality', (WidgetTester tester) async {
//   // Arrange
//   when(() => mockNewsBloc.state).thenReturn( NewsInitial());
//   when(() => mockNewsBloc.add(any())).thenAnswer((_) async => null); // Mock add behavior

//   await tester.pumpWidget(buildTestableWidget());

//   // Act
//   await tester.enterText(find.byType(TextField), 'Flutter');
//   await tester.tap(find.byIcon(Icons.search));
//   await tester.pumpAndSettle(); // Ensure all animations are settled

//   // Assert
//   verify(() => mockNewsBloc.add(const LoadNewsEvent(query: 'Flutter'))).called(1);
// });

//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:news_app/core/theme/theme_manager.dart';
import 'package:news_app/features/manage_news/domain/entities/news_entity.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_event.dart';
import 'package:news_app/features/manage_news/presentation/bloc/news_state.dart';
import 'package:news_app/features/manage_news/presentation/pages/news_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fake_classes.dart';

class MockNewsBloc extends MockBloc<NewsEvent, NewsState> implements NewsBloc {}

void main() {
  group('NewsPage Widget Tests', () {
    late MockNewsBloc mockNewsBloc;
    late ThemeManager themeManager;

    setUpAll(() {
      registerFallbackValue(FakeNewsEvent());
      registerFallbackValue(FakeNewsState());
    });

    setUp(() async {
      SharedPreferences.setMockInitialValues({}); // Mock SharedPreferences
      mockNewsBloc = MockNewsBloc();
     // final theme = await ThemeManager.loadTheme();//updates required
      //themeManager = ThemeManager(theme);
      themeManager = ThemeManager(ThemeData.light());
      when(() => mockNewsBloc.state).thenReturn(NewsInitial());
    });

    Widget buildTestableWidget() {
      return MaterialApp(
        theme: themeManager.value,
        home: Scaffold(
          body: BlocProvider<NewsBloc>.value(
            value: mockNewsBloc,
            child: NewsPage(themeManager: themeManager),
          ),
        ),
      );
    }

    testWidgets('should display "No news available" message', (WidgetTester tester) async {
      // Arrange
      // when(() => mockNewsBloc.state).thenReturn(const NewsLoaded(news: [], hasMoreData: false));
       when(() => mockNewsBloc.state).thenReturn(NewsInitial());
      whenListen(
        mockNewsBloc,
        Stream.fromIterable([
          NewsInitial(),
          const NewsLoaded(news: [], hasMoreData: false),
        ]),
      );

      // Act
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('No news available'), findsOneWidget);
    });

    testWidgets('should show CircularProgressIndicator while loading', (WidgetTester tester) async {
      // Arrange
      when(() => mockNewsBloc.state).thenReturn(const NewsLoading());

      // Act
      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show list of news articles when loaded', (WidgetTester tester) async {
      // Arrange
      final articles = [
        const NewsEntity(title: 'News 1', description: 'Description 1', imageUrl: ''),
        const NewsEntity(title: 'News 2', description: 'Description 2', imageUrl: ''),
      ];
      when(() => mockNewsBloc.state).thenReturn(NewsLoaded(news: articles, hasMoreData: false));

      // Act
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('News 1'), findsOneWidget);
      expect(find.text('News 2'), findsOneWidget);
    });

    testWidgets('should allow search functionality', (WidgetTester tester) async {
      // Arrange
      print(mockNewsBloc.state);
      when(() => mockNewsBloc.state).thenReturn(NewsInitial());
      await tester.pumpWidget(buildTestableWidget());

      // Act
      await tester.enterText(find.byType(TextField), 'Flutter');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Assert
      verify(() => mockNewsBloc.add(LoadNewsEvent(query: 'Flutter'))).called(1);
    });

    testWidgets('should toggle theme and persist preference', (WidgetTester tester) async {
      // Arrange
      final prefs = await SharedPreferences.getInstance();
      //expect(prefs.getBool('isDarkMode'), isNull); // Initial state
      expect(prefs.getBool('isDarkMode'), isFalse);

      await tester.pumpWidget(buildTestableWidget());
      final switchFinder = find.byType(Switch);

      // Act: Enable dark mode
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Assert: Verify the dark mode is applied and stored
      expect(themeManager.value, ThemeData.dark());
      //expect(prefs.getBool('isDarkMode'), true);
      expect(prefs.getBool('isDarkMode'),isTrue);

      // Act: Disable dark mode
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Assert: Verify the light mode is applied and stored
      expect(themeManager.value, ThemeData.light());
      //expect(prefs.getBool('isDarkMode'), false);
      expect(prefs.getBool('isDarkMode'), isFalse);
    });
  });
}
