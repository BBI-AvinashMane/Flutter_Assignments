
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            accountName: const Text(Constants.welcomeText),
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
            title: const Text(Constants.logoutText),
            onTap: () async {
              final shouldLogout = await _showLogoutDialog(context);
              if (shouldLogout) {
                // Clear shared preferences
                await _clearSharedPreferences();

                // Trigger LogoutEvent
                BlocProvider.of<AuthenticateBloc>(context).add(LogoutEvent(context));

                // Navigate to login or home screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/', // Replace with your login or home route
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _clearSharedPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(Constants.filterByPriority);
    await preferences.remove(Constants.priorityLevel);
    await preferences.remove(Constants.filterByDueDate);
    await preferences.remove(Constants.userId);
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(Constants.confirmLogoutTitle),
            content: const Text(Constants.confirmLogoutMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(Constants.cancelButton),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(Constants.logoutButton),
              ),
            ],
          ),
        ) ??
        false;
  }
}
