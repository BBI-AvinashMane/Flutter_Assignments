import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/theme/theme_manager.dart';
import 'package:news_app/features/manage_news/presentation/pages/news_list.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import 'filter_dialogue.dart';

class NewsPage extends StatefulWidget {
  final ThemeManager themeManager;

  const NewsPage({Key? key, required this.themeManager}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Trigger default news fetch
    context.read<NewsBloc>().add(const LoadNewsEvent(query: 'latest'));
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<NewsBloc>().add(LoadNewsEvent(query: query));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search term')),
      );
    }
  }

  void _openFilterDialog(BuildContext context) {
    final blocContext = context;

    showDialog(
      context: context,
      builder: (dialogContext) => FilterDialog(
        onApply: ({required String? query, required String? language}) {
          blocContext.read<NewsBloc>().add(
            LoadNewsEvent(
              query: query ?? _searchController.text.trim(), // Use search query if available
              language: language,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          Switch(
            value: widget.themeManager.value == ThemeData.dark(),
            onChanged: (value) => widget.themeManager.toggleTheme(value),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _openFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
