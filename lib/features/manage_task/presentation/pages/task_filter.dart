
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskFilterPage extends StatefulWidget {
  final String userId;
  final String? priorityLevel;

  const TaskFilterPage({Key? key, required this.userId, this.priorityLevel}) : super(key: key);

  @override
  _TaskFilterPageState createState() => _TaskFilterPageState();
}

class _TaskFilterPageState extends State<TaskFilterPage> {
  bool _filterByPriorityOrder = false;
  bool _filterByDueDate = false;
  String? _specificPriority;

  final List<String> _priorities = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _filterByPriorityOrder = preferences.getBool('filterByPriorityOrder') ?? false;
      _filterByDueDate = preferences.getBool('filterByDueDate') ?? false;
      _specificPriority = preferences.getString('specificPriority');
      if (_filterByPriorityOrder) {
        _specificPriority = null; // Clear specific priority if priority order is selected
      }
    });
  }

  Future<void> _saveFilters() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool('filterByPriorityOrder', _filterByPriorityOrder);
    preferences.setBool('filterByDueDate', _filterByDueDate);
    preferences.setString('specificPriority', _specificPriority ?? '');
  }

  Future<void> _resetFilters() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('filterByPriorityOrder');
    await preferences.remove('filterByDueDate');
    await preferences.remove('specificPriority');

    setState(() {
      _filterByPriorityOrder = false;
      _filterByDueDate = false;
      _specificPriority = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Tasks"),
        actions: [
          TextButton(
            onPressed: () async {
              await _resetFilters();
              Navigator.pop(context, {
                'filterByPriorityOrder': false,
                'filterByDueDate': false,
                'specificPriority': null,
              });
            },
            child: const Text(
              "Reset",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text("Priority Order (High > Medium > Low)"),
              value: _filterByPriorityOrder,
              onChanged: (value) {
                setState(() {
                  _filterByPriorityOrder = value ?? false;
                  if (_filterByPriorityOrder) {
                    _specificPriority = null; // Clear specific priority if Priority Order is selected
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _specificPriority,
              items: _priorities
                  .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              onChanged: _filterByPriorityOrder
                  ? null // Disable dropdown if Priority Order is checked
                  : (value) {
                      setState(() {
                        _specificPriority = value;
                      });
                    },
              decoration: const InputDecoration(labelText: 'Specific Priority'),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text("Sort by Due Date"),
              value: _filterByDueDate,
              onChanged: (value) {
                setState(() {
                  _filterByDueDate = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _saveFilters();
                Navigator.pop(context, {
                  'filterByPriorityOrder': _filterByPriorityOrder,
                  'filterByDueDate': _filterByDueDate,
                  'specificPriority': _specificPriority,
                });
              },
              child: const Text("Apply Filters"),
            ),
          ],
        ),
      ),
    );
  }
}
