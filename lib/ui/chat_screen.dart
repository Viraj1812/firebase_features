import 'package:firebase_features/services/firebase_auth_service.dart';
import 'package:firebase_features/ui/auth/auth_screen.dart';
import 'package:firebase_features/widgets/chat_messages.dart';
import 'package:firebase_features/widgets/new_message.dart';
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
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'deleteAccount') {
                _authHelper.userDeleteAccount(context);
              } else if (value == 'signOut') {
                _authHelper.signOut(context).then((value) =>
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()),
                        (route) => false));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'deleteAccount',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete Account'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'signOut',
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Sign Out'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessage(),
        ],
      ),
    );
  }
}
