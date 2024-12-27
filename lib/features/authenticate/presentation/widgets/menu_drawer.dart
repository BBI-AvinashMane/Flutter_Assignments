import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_bloc.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/bloc/authenticate_event.dart';
import 'package:task_manager_firebase/features/authenticate/presentation/widgets/logout_dialog.dart';

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
            accountName: Text("Welcome"),
            accountEmail: Text(userId),
            currentAccountPicture: CircleAvatar(
              child: Text(
                userId.split("_")[1], // Display the user number (e.g., 1 for user_1)
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              final shouldLogout = await showLogoutDialog(context);
              if (shouldLogout) {
                BlocProvider.of<AuthenticateBloc>(context).add(LogoutEvent());
              }
            },
          ),
        ],
      ),
    );
  }
}
