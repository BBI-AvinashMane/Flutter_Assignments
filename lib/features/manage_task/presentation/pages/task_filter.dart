import 'package:flutter/material.dart';

class TaskFilterPage extends StatefulWidget {
  final String userId;
  final String? priorityLevel; // Add this parameter to the constructor

  const TaskFilterPage({Key? key, required this.userId, this.priorityLevel}) : super(key: key);

  @override
  _TaskFilterPageState createState() => _TaskFilterPageState();
}

class _TaskFilterPageState extends State<TaskFilterPage> {
  bool _filterByPriorityOrder = false;
  bool _filterByDueDate = false;
  String? _specificPriority;

  @override
  void initState() {
    super.initState();
    _specificPriority = widget.priorityLevel; // Use priorityLevel if provided
  }

  void _resetFilters() {
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
            onPressed: () {
              _resetFilters(); // Reset filters visually
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
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _specificPriority,
              items: ['High', 'Medium', 'Low']
                  .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              onChanged: (value) {
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
              onPressed: () {
                // Apply filters and pass back to TaskList
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
