import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Function({
    required String? query,
    required String? language,
  }) onApply;

  const FilterDialog({Key? key, required this.onApply}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _selectedLanguage;

  final Map<String, String> languageMap = {
    'en': 'English',
    'fr': 'French',
    'de': 'German',
    'es': 'Spanish',
    'it': 'Italian',
    'ar': 'Arabic',
    'zh': 'Chinese',
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter News'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedLanguage,
              hint: const Text('Select Language'),
              items: languageMap.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(
              query: null,
              language: _selectedLanguage,
            );
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
