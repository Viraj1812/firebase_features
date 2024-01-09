import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_features/ui/auth/auth_screen.dart';
import 'package:firebase_features/utils/helper_methods.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          IconButton(
            onPressed: () {
              userDeleteAccount(context);
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              userSignOut().then((value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
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

  Future<void> userDeleteAccount(BuildContext context) async {
    try {
      Utils.showToast(context, 'Account deleted successfully.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      Utils.showToast(context, 'Error deleting account: ${e.toString()}');
    }
  }

  Future<void> userSignOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
