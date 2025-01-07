import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Logout",key: Key('logoutDialogTitle'),),
            content: const Text("Are you sure you want to log out?",key: Key('logoutDialogContent'),),
            actions: [
              TextButton(
                key: const Key('cancelButton'),
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                key: const Key('logoutButton'), 
                onPressed: () => Navigator.pop(context, true),
                child: Text("Logout"),
              ),
            ],
          );
        },
      ) ??
      false;
}
