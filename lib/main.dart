import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/core/network/api_client.dart';
import 'core/shared/shared_pref.dart';
import 'core/theme/theme_manager.dart';
import 'features/manage_news/data/data_sources/news_remote_data_source.dart';
import 'features/manage_news/data/repository/news_repository_impl.dart';
import 'features/manage_news/domain/usecases/get_news.dart';
import 'features/manage_news/presentation/bloc/news_bloc.dart';
import 'features/manage_news/presentation/pages/news_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final apiClient = ApiClient(http.Client());
  final sharedPrefs = SharedPrefs();
  final isDarkMode = await sharedPrefs.getDarkMode();
  final themeManager =
      ThemeManager(isDarkMode ? ThemeData.dark() : ThemeData.light());

  runApp(MyApp(
    // apiClient: apiClient,
    themeManager: themeManager,
    sharedPrefs: sharedPrefs,
  ));
}

class MyApp extends StatelessWidget {
  // final ApiClient apiClient;
  final ThemeManager themeManager;
  final SharedPrefs sharedPrefs;

  const MyApp({
    Key? key,
    // required this.apiClient,
    required this.themeManager,
    required this.sharedPrefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeManager,
      builder: (context, theme, _) {
        return MaterialApp(
          theme: theme,
          home: BlocProvider(
            create: (_) => NewsBloc(
              GetNews(
                // NewsRepositoryImpl(NewsRemoteDataSource(apiClient)),
                NewsRepositoryImpl(
                  NewsRemoteDataSource(),
                ),
              ),
            ),
            child: NewsPage(themeManager: themeManager),
          ),
        );
      },
    );
  }
}
