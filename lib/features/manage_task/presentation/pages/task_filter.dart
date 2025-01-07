import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';

class TaskFilterPage extends StatefulWidget {
  final String userId;
  final String? priorityLevel;

  const TaskFilterPage({Key? key, required this.userId, this.priorityLevel})
      : super(key: key);

  @override
  _TaskFilterPageState createState() => _TaskFilterPageState();
}

class _TaskFilterPageState extends State<TaskFilterPage> {
  bool _filterByPriorityOrder = false;
  bool _filterByDueDate = false;
  String? _specificPriority;

  final List<String> _priorities = [Constants.priorityHighText, Constants.priorityMediumText, Constants.priorityLowText];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _filterByPriorityOrder =
          preferences.getBool(Constants.filterByPriorityOrder) ?? false;
      _filterByDueDate = preferences.getBool(Constants.filterByDueDate) ?? false;
      _specificPriority = preferences.getString(Constants.specificPriority);

      // Ensure _specificPriority is valid
      if (!_priorities.contains(_specificPriority)) {
        _specificPriority = null;
      }

      if (_filterByPriorityOrder) {
        _specificPriority =
            null; // Clear specific priority if Priority Order is selected
      }
    });
  }

  Future<void> _saveFilters() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(Constants.filterByPriorityOrder, _filterByPriorityOrder);
    preferences.setBool(Constants.filterByDueDate, _filterByDueDate);
    preferences.setString(Constants.specificPriority, _specificPriority ?? '');
   // debugPrint('Saved Sort by Due Date: $_filterByDueDate');
  }

  Future<void> _resetFilters() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(Constants.filterByPriorityOrder);
    await preferences.remove(Constants.filterByDueDate);
    await preferences.remove(Constants.specificPriority);

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
        title: const Text(Constants.filterTasks),
        actions: [
          TextButton(
            onPressed: () async {
              await _resetFilters();
              Navigator.pop(context, {
                Constants.filterByPriorityOrder: false,
                Constants.filterByDueDate: false,
                Constants.specificPriority: null,
              });
            },
            child: const Text(
              Constants.resetFilters,
              style: TextStyle(color: Color.fromARGB(255, 245, 30, 6)),
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
              key: const Key(Constants.priorityOrderCheckbox),
              title: const Text(Constants.priorityOrderText),
              value: _filterByPriorityOrder,
              onChanged: (value) {
                setState(() {
                  _filterByPriorityOrder = value ?? false;
                  // debugPrint('Checkbox toggled: $_filterByPriorityOrder');
                  if (_filterByPriorityOrder) {
                    _specificPriority =
                        null; // Clear specific priority if Priority Order is selected
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: const Key(Constants.specificPriorityDropdown),
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
                         _saveFilters();//added while testing
                      });
                    },
              decoration: const InputDecoration(labelText: Constants.specificPriorityLabel),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text(Constants.sortByDuedate),
              value: _filterByDueDate,
              onChanged: (value) {
                setState(() {
                  _filterByDueDate = value ?? false;
                  //debugPrint('Sort by Due Date toggled: $_filterByDueDate');
                  if (_filterByPriorityOrder) {
                    _specificPriority =
                        null; // Clear specific priority if Priority Order is selected
                  } // this if statement is added while testing
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _saveFilters();
                Navigator.pop(context, {
                 Constants.filterByPriorityOrder: _filterByPriorityOrder,
                  Constants.filterByDueDate: _filterByDueDate,
                 Constants.specificPriority: _specificPriority,
                });
              },
              child: const Text(Constants.applyFilters),
            ),
          ],
        ),
      ),
    );
  }
}
