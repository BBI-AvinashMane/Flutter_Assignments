
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data_model.dart';

class DataHandling extends StatefulWidget {
  const DataHandling({super.key});

  @override
  State<DataHandling> createState() => _DataHandlingState();
}

class _DataHandlingState extends State<DataHandling> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  List<DataModel> allData = [];
  List<DataModel> filteredData = [];
  List<int> pinnedIds = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isSearching = false;
  int currentPage = 1;
  bool hasMoreData = true;

  String? lastSearchQuery;
  bool showLastSearchBanner = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    loadPinnedItems();
    loadLastSearchQuery();
    fetchData();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >=
    //           _scrollController.position.maxScrollExtent - 200 &&
    //       !isLoading &&
    //       hasMoreData) {
    //     fetchData();
    //   }
    // });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        fetchData();
      }
    });
  }

  Future<void> loadPinnedItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? pinned = prefs.getStringList('pinnedItems');
    if (pinned != null) {
      setState(() {
        pinnedIds = pinned.map(int.parse).toList();
      });
    }
  }

  Future<void> savePinnedItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'pinnedItems', pinnedIds.map((e) => e.toString()).toList());
  }

  Future<void> loadLastSearchQuery() async {
    final prefs = await SharedPreferences.getInstance();
    lastSearchQuery = prefs.getString('lastSearchQuery');
    if (lastSearchQuery != null && lastSearchQuery!.isNotEmpty) {
      setState(() {
        showLastSearchBanner = true;
      });
      _fadeController.forward();
    }
  }

  Future<void> saveLastSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchQuery', query);
  }

  Future<void> fetchData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    const int itemsPerPage = 10;
    var url = Uri.parse(
        "https://jsonplaceholder.typicode.com/posts?_page=$currentPage&_limit=$itemsPerPage");
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      final List body = json.decode(response.body);
      if (body.isEmpty) {
        setState(() {
          hasMoreData = false;
        });
      } else {
        setState(() {
          currentPage++;
          List<DataModel> newData =
              body.map((e) => DataModel.fromJson(e)).toList();
          allData.addAll(newData);
          if (!isSearching) {
            filteredData.addAll(newData);
          }
        });
      }
    } else {
      throw Exception("Failed to load data");
    }

    setState(() {
      isLoading = false;
    });
  }

  void filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = allData;
        isSearching = false;
      });
    } else {
      setState(() {
       isSearching = true;
        filteredData = allData
            .where((item) => item.title != null &&
                item.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
      saveLastSearchQuery(query);
    }
  }

  void togglePin(int id) {
    setState(() {
      if (pinnedIds.contains(id)) {
        pinnedIds.remove(id);
      } else {
        pinnedIds.add(id);
      }
      savePinnedItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Separate pinned and non-pinned items
    final pinnedItems =
        filteredData.where((item) => pinnedIds.contains(item.id)).toList();
    final nonPinnedItems =
        filteredData.where((item) => !pinnedIds.contains(item.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text("Search and Paginate")
            : TextField(
                controller: searchController,
                onChanged: filterData,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              if (isSearching) {
                setState(() {
                  isSearching = false;
                  filteredData = allData;
                  searchController.clear();
                  saveLastSearchQuery('');
                });
              } else {
                setState(() {
                  isSearching = true;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (showLastSearchBanner)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                color: Colors.blue.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last search: $lastSearchQuery",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        searchController.text = lastSearchQuery!;
                        filterData(lastSearchQuery!);
                        setState(() {
                          showLastSearchBanner = false;
                        });
                      },
                      child: const Text("Reuse"),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: pinnedItems.length + nonPinnedItems.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < pinnedItems.length) {
                  return buildCard(pinnedItems[index], isPinned: true);
                } else if (index < pinnedItems.length + nonPinnedItems.length) {
                  final nonPinnedIndex = index - pinnedItems.length;
                  return buildCard(nonPinnedItems[nonPinnedIndex], isPinned: false);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(DataModel data, {required bool isPinned}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isPinned ? Colors.yellow.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(
              data.id.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title ?? "No Title",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  data.body ?? "No Description",
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: isPinned ? Colors.orange : Colors.grey,
            ),
            onPressed: data.id != null ? () => togglePin(data.id!) : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
