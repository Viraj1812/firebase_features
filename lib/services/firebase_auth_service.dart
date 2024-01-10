import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_features/ui/auth/auth_screen.dart';
import 'package:firebase_features/ui/chat_screen.dart';
import 'package:firebase_features/utils/helper_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Utils.showToast(context, 'Account Login successfull.');
      debugPrint(userCredential.toString());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      Utils.showToast(context, e.toString());
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
    File? selectedImage,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredential.user?.uid}.jpg');

      await storageRef.putFile(selectedImage!);
      final imageURL = await storageRef.getDownloadURL();
      debugPrint(imageURL);

      debugPrint(userCredential.toString());
      Utils.showToast(context, 'Account Created successfully.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      Utils.showToast(context, e.toString());
    }
    return null;
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled Google Sign-In
        return null;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      Utils.showToast(context, 'Account Login successfull.');
      return userCredential.user;
    } catch (e) {
      Utils.showToast(context, e.toString());
    }
    return null;
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Utils.showToast(context, 'Account Logout successfull.');
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int) codeSent,
    required BuildContext context,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Utils.showToast(context, e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSent(verificationId, resendToken ?? 0);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      Utils.showToast(context, e.toString());
    }
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

  Future<void> verifyCode(
      String verificationId, String smsCode, BuildContext context) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(),
        ),
        (route) => false,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      Utils.showToast(context, e.toString());
    }
  }
}
