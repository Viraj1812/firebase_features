import 'package:firebase_features/services/firebase_auth_service.dart';
import 'package:firebase_features/services/local_notification_service.dart';
import 'package:firebase_features/ui/auth/auth_screen.dart';
import 'package:firebase_features/utils/helper_methods.dart';
import 'package:firebase_features/widgets/chat_messages.dart';
import 'package:firebase_features/widgets/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String notificationMsg = '';
  final AuthHelper _authHelper = AuthHelper();

  @override
  void initState() {
    super.initState();

    LocalNotificationService.initilize();

    FirebaseMessaging.instance.getInitialMessage().then(
      (event) {
        Utils.showToast(context,
            "${event?.notification?.title} ${event?.notification?.body} I am coming from terminated State");
        debugPrint('Terminated State');
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        Utils.showToast(context,
            "${event.notification?.title} ${event.notification?.body} I am coming from backGround");
        debugPrint('BackGround State');
      },
    );
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.showNotificationOnForeground(event);
      Utils.showToast(context,
          "${event.notification?.title} ${event.notification?.body} I am coming from foreground");
      debugPrint('Foreground State');
    });
  }

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
