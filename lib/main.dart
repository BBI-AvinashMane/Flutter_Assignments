

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/core/theme/theme_manager.dart';
import 'features/manage_news/presentation/pages/news_page.dart';
import 'features/manage_news/presentation/bloc/news_bloc.dart';
import 'features/manage_news/domain/usecases/get_news.dart';
import 'features/manage_news/data/repository/news_repository_impl.dart';
import 'features/manage_news/data/data_sources/news_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await dotenv.load(fileName: ".env");
  // Load the saved theme
  final theme = await ThemeManager.loadTheme();
  final themeManager = ThemeManager(theme);

  runApp(MyApp(themeManager: themeManager));
}

class MyApp extends StatelessWidget {
  final ThemeManager themeManager;

  const MyApp({Key? key, required this.themeManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeManager,
      builder: (context, theme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: BlocProvider(
            create: (_) => NewsBloc(
              GetNews(
                NewsRepositoryImpl(NewsRemoteDataSourceImpl(http.Client())),
              ),
            ),
            child: NewsPage(themeManager: themeManager),
          ),
        );
      },
    );
  }
}
