import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_features/services/firebase_auth_service.dart';
import 'package:firebase_features/ui/auth/login_with_phone_number.dart';
import 'package:firebase_features/ui/chat_screen.dart';
import 'package:firebase_features/utils/helper_methods.dart';
import 'package:firebase_features/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _enteredEmail = '';
  String _enteredPassword = '';
  File? _selectedImage;
  bool _isAuthenticating = false;

  bool _isGoogleSignInLoading = false;
  final AuthHelper _authHelper = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: Icon(Icons.email)),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredEmail = newValue!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.password)),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: () {
                                _submit();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black87),
                              child: Text(
                                _isLogin ? 'Login' : 'Signup',
                                style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Create an account'
                                    : 'I already have an account',
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithPhoneNumber(),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white)),
                  child: Center(
                    child: Text(
                      'Login with phone',
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => _handleGoogleSignIn(),
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isGoogleSignInLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : Image.asset(
                              'assets/images/google_logo.png',
                              height: 24.0,
                              width: 24.0,
                            ),
                      const SizedBox(width: 30),
                      const Text(
                        'Sign In with Google',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      setState(() {
        _isGoogleSignInLoading = true;
      });

      User? user = await _authHelper.signInWithGoogle(context);

      if (user == null) {
        setState(() {
          _isGoogleSignInLoading = false;
        });
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isGoogleSignInLoading = false;
      });
    }
  }

  void _submit() async {
    final isValid = _formKey.currentState?.validate();

    if (isValid == false || (!_isLogin && _selectedImage == null)) {
      return;
    }

    _formKey.currentState?.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        User? user = await _authHelper.signInWithEmailAndPassword(
          _enteredEmail,
          _enteredPassword,
          context,
        );
        debugPrint(user.toString());
      } else {
        User? user = await _authHelper.createUserWithEmailAndPassword(
          _enteredEmail,
          _enteredPassword,
          context,
          _selectedImage,
        );
        debugPrint(user.toString());
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Authentication Failed';
      if (error.code == 'INVALID_LOGIN_CREDENTIALS') {
        errorMessage = 'User not found. Please check your Credentials.';
      }
      debugPrint(error.message);
      ScaffoldMessenger.of(context).clearSnackBars();
      Utils.showToast(
        context,
        (errorMessage == 'Authentication Failed')
            ? error.message ?? 'Authentication Failed'
            : errorMessage,
      );

      setState(() {
        _isAuthenticating = false;
      });
    }
  }
}
