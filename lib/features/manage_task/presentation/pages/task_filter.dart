import 'package:flutter/material.dart';

class FilterAndSortTasksPage extends StatefulWidget {
  final String userId;

  const FilterAndSortTasksPage({required this.userId, Key? key}) : super(key: key);

  @override
  _FilterAndSortTasksPageState createState() => _FilterAndSortTasksPageState();
}

class _FilterAndSortTasksPageState extends State<FilterAndSortTasksPage> {
  bool _filterByPriority = false;
  bool _filterByDueDate = false;
  String? _selectedPriorityLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter and Sort Tasks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text("Filter by Priority"),
              value: _filterByPriority,
              onChanged: (value) {
                setState(() {
                  _filterByPriority = value ?? false;
                  if (!_filterByPriority) _selectedPriorityLevel = null; // Reset priority level
                });
              },
            ),
            if (_filterByPriority)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Priority Level"),
                value: _selectedPriorityLevel,
                onChanged: (value) {
                  setState(() {
                    _selectedPriorityLevel = value;
                  });
                },
                items: const [
                  DropdownMenuItem(value: "High", child: Text("High")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "Low", child: Text("Low")),
                ],
              ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text("Sort by Due Date"),
              value: _filterByDueDate,
              onChanged: (value) {
                setState(() {
                  _filterByDueDate = value ?? false;
                });
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back without applying filters
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Pass filter and sort options back to the task list
                    Navigator.pop(context, {
                      'filterByPriority': _filterByPriority,
                      'priorityLevel': _selectedPriorityLevel,
                      'filterByDueDate': _filterByDueDate,
                    });
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
