import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Logout"),
              ),
            ],
          );
        },
      ) ??
      false;
}
