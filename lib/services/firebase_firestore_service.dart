import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStoreHelper {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage storageRef = FirebaseStorage.instance;

  Future<void> uploadImageAndUpdateUserData(String? userId, String email,
      File? selectedImage, String enterUsername) async {
    if (userId != null && selectedImage != null) {
      final store = storageRef.ref().child('user_images').child('$userId.jpg');

      await store.putFile(selectedImage);
      final imageURL = await store.getDownloadURL();

      await firebaseFirestore.collection('users').doc(userId).set({
        'username': enterUsername,
        'email': email,
        'image_url': imageURL,
      });

      debugPrint(imageURL);
    }
  }

  Future<void> submitMessage(String enteredMessage, String userId) async {
    if (enteredMessage.trim().isEmpty) {
      return;
    }

    final userData =
        await firebaseFirestore.collection('users').doc(userId).get();

    await firebaseFirestore.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'username': userData.data()?['username'],
      'userImage': userData.data()?['image_url'],
    });
  }
}
