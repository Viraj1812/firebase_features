import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_features/services/firebase_firestore_service.dart';
import 'package:firebase_features/ui/auth/auth_screen.dart';
import 'package:firebase_features/ui/chat_screen.dart';
import 'package:firebase_features/utils/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FireStoreHelper _fireStoreHelper = FireStoreHelper();
  Future<User?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await firebaseAuth
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
    String enterUsername,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _fireStoreHelper.uploadImageAndUpdateUserData(
          userCredential.user?.uid, email, selectedImage, enterUsername);
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
          await firebaseAuth.signInWithCredential(credential);
      Utils.showToast(context, 'Account Login successfull.');
      return userCredential.user;
    } catch (e) {
      Utils.showToast(context, e.toString());
    }
    return null;
  }

  Future<void> signOut(BuildContext context) async {
    await firebaseAuth.signOut();
    Utils.showToast(context, 'Account Logout successfull.');
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int) codeSent,
    required BuildContext context,
  }) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
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
      await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      Utils.showToast(context, e.toString());
    }
  }
}
