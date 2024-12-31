import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart';

class MenuDrawer extends StatelessWidget {
  final String userId;

  const MenuDrawer({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Welcome"),
            accountEmail: Text(userId),
            currentAccountPicture: CircleAvatar(
              child: Text(
                userId.split("_")[1], // Display user number (e.g., 1 for user_1)
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              final shouldLogout = await _showLogoutDialog(context);
              if (shouldLogout) {
                BlocProvider.of<AuthenticateBloc>(context).add(LogoutEvent(context));//LogoutEvent(context) here context added
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false, // Clear all previous routes
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Display a confirmation dialog for logout
  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Logout"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Logout"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
