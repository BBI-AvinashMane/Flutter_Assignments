import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/shared/shared_pref.dart';
import 'core/theme/theme_manager.dart';
import 'features/manage_news/data/data_sources/news_remote_data_source.dart';
import 'features/manage_news/data/repository/news_repository_impl.dart';
import 'features/manage_news/domain/usecases/get_news.dart';
import 'features/manage_news/presentation/bloc/news_bloc.dart';
import 'features/manage_news/presentation/pages/news_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: "lib/.env");

  // Initialize shared preferences and theme manager
  final sharedPrefs = SharedPrefs();
  final isDarkMode = await sharedPrefs.getDarkMode();
  final themeManager =
      ThemeManager(isDarkMode ? ThemeData.dark() : ThemeData.light());

  runApp(MyApp(themeManager: themeManager, sharedPrefs: sharedPrefs));
}

class MyApp extends StatelessWidget {
  final ThemeManager themeManager;
  final SharedPrefs sharedPrefs;

  const MyApp({
    Key? key,
    required this.themeManager,
    required this.sharedPrefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeManager,
      builder: (context, theme, _) {
        return BlocProvider(
          create: (_) => NewsBloc(
            getNews: GetNews(
              NewsRepositoryImpl(
                NewsRemoteDataSourceImpl(),
              ),
            ),
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: NewsPage(themeManager: themeManager),
          ),
        );
      },
    );
  }
}
