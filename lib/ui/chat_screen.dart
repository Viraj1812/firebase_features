import 'package:firebase_features/services/firebase_auth_service.dart';
import 'package:firebase_features/ui/auth/auth_screen.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final AuthHelper _authHelper = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          IconButton(
            onPressed: () {
              _authHelper.userDeleteAccount(context);
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              _authHelper.signOut(context).then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()),
                      (route) => false));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: const Center(
        child: Text('Logged in!'),
      ),
    );
  }
}
