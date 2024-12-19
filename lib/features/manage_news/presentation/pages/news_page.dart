import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/theme/theme_manager.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import 'news_list.dart';
import 'filter_dialogue.dart';

class NewsPage extends StatefulWidget {
  final ThemeManager themeManager;

  const NewsPage({Key? key, required this.themeManager}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _currentQuery = 'cricket';
  int _currentPage = 1;
  bool _isFetching = false;

  void _fetchNews() {
    context
        .read<NewsBloc>()
        .add(LoadNewsEvent(query: _currentQuery, page: _currentPage));
  }

  void _loadMoreNews() {
    if (_isFetching) return;

    setState(() {
      _isFetching = true;
    });
    context
        .read<NewsBloc>()
        .add(LoadNewsEvent(query: _currentQuery, page: ++_currentPage));
  }

  void _refreshNews() async {
    setState(() {
      _currentPage = 1;
      _isFetching = false;
    });
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate a slight delay
    context.read<NewsBloc>().add(RefreshNewsEvent(query: _currentQuery));
  }

  @override
  void initState() {
    super.initState();
    _fetchNews();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isFetching) {
        _loadMoreNews();
      }
    });
  }

  // void _onSearch() {
  //   setState(() {
  //     _currentQuery = _searchController.text.trim().isEmpty
  //         ? 'cricket'
  //         : _searchController.text.trim();
  //     _currentPage = 1;
  //     _isFetching = false;
  //   });
  //   _fetchNews();
  //   _refreshNews();
  // }
  void _onSearch() {
    // Trim and sanitize the search query
    final query = _searchController.text.trim();

    setState(() {
      // If the query is empty, default to 'cricket'
      _currentQuery = query.isEmpty ? 'cricket' : query;

      // Reset pagination and fetching flags
      _currentPage = 1;
      _isFetching = false;
    });

    // Trigger the fetch and refresh methods
    if (query.isNotEmpty || _currentQuery == 'cricket') {
      _fetchNews(); // Fetch news for the updated query
      _refreshNews(); // Refresh news to handle state updates
    } else {
      // If query is empty, optionally show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search term')),
      );
    }
  }

  void _openFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => FilterDialog(
        onApply: ({
          required String query,
          required String? language,
        }) {
          context.read<NewsBloc>().add(
                LoadNewsEvent(
                  query: _currentQuery,
                  language: language,
                ),
              );
        },
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
                    _onSearch();
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
            child: RefreshIndicator(
              onRefresh: () async => _refreshNews(),
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoading ||
                      (state is NewsLoading && state.isRefreshing)) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NewsLoaded) {
                    _isFetching = false;
                    if (state.news.isEmpty) {
                      return const Center(child: Text('No news available'));
                    }
                    return NewsList(
                      news: state.news,
                      scrollController: _scrollController,
                      hasMoreData: state.hasMoreData,
                    );
                  } else if (state is NewsError) {
                    //const Center(child: Text('No news available'));
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('No news available'));
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          _scrollController.hasClients && _scrollController.offset > 300
              ? FloatingActionButton(
                  onPressed: _scrollToTop,
                  child: const Icon(Icons.arrow_upward),
                )
              : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
