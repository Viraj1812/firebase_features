import 'package:firebase_features/services/firebase_auth_service.dart';
import 'package:firebase_features/services/firebase_cloud_messaging.dart';
import 'package:firebase_features/services/firebase_firestore_service.dart';
import 'package:firebase_features/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();
  final AuthHelper _authHelper = AuthHelper();
  final FCMHelper _fcmHelper = FCMHelper();

  @override
  void initState() {
    super.initState();
    _fcmHelper.setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = _authHelper.firebaseAuth.currentUser!;
    return StreamBuilder(
      stream: _fireStoreHelper.firebaseFirestore
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
          ).copyWith(bottom: 40),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final chatMessages = loadedMessages[index].data();
            final messageId = loadedMessages[index].id;
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessages['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;

            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            return Dismissible(
              key: Key(messageId),
              onDismissed: (direction) {
                // Handle swipe to delete
                _fireStoreHelper.deleteMessage(
                  messageId,
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: GestureDetector(
                onLongPress: () {
                  // Show delete popup
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Message?'),
                        content: const Text(
                            'Are you sure you want to delete this message?'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle delete on tap
                              _fireStoreHelper.deleteMessage(messageId);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: nextUserIsSame
                    ? MessageBubble.next(
                        message: chatMessages['text'],
                        isMe: authenticatedUser.uid == currentMessageUserId,
                      )
                    : MessageBubble.first(
                        userImage: chatMessages['userImage'],
                        username: chatMessages['username'],
                        message: chatMessages['text'],
                        isMe: authenticatedUser.uid == currentMessageUserId,
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
