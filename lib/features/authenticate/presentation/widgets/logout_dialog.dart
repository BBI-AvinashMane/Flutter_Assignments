import 'package:flutter/material.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';

Future<bool> showLogoutDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(Constants.logoutTitle,key: Key(Constants.logoutDialogTitleKey),),
            content: const Text(Constants.logoutonfirmation,key: Key(Constants.logoutDialogContentKey),),
            actions: [
              TextButton(
                key: const Key(Constants.cancelButtonKey),
                onPressed: () => Navigator.pop(context, false),
                child: const Text(Constants.logoutCancelText),
              ),
              ElevatedButton(
                key: const Key(Constants.logoutButtonKey), 
                onPressed: () => Navigator.pop(context, true),
                child: const Text(Constants.logoutButton),
              ),
            ],
          );
        },
      ) ??
      false;
}
