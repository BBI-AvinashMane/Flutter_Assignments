// features/manage_news/presentation/pages/news_page.dart

import 'package:flutter/material.dart';
import 'package:news_app/core/theme/theme_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/manage_news/presentation/pages/news_list.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';


class NewsPage extends StatelessWidget {
  final ThemeManager themeManager;

  const NewsPage({Key? key, required this.themeManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewsBloc>();
    bloc.add(LoadNewsEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              themeManager.toggleTheme(value);
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            return NewsList(news: state.news);
          } else if (state is NewsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No news available'));
        },
      ),
    );
  }
}
