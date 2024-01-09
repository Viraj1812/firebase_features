import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_features/ui/auth/verify_code.dart';
import 'package:firebase_features/utils/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  TextEditingController phoneController = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              hintText: '+911234567890',
                              prefixIcon: Icon(Icons.phone)),
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          validator: (value) {
                            final phoneRegex = RegExp(r'^\+91[6-9]\d{9}$');
                            if (value == null) {
                              return 'Please enter phone number';
                            }
                            return phoneRegex.hasMatch(value)
                                ? null
                                : 'Please enter a valid Indian phone number.';
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  _submit();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87),
                                child: Text(
                                  'Continue',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    setState(() {
      loading = true;
    });
    auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        Utils.showToast(context, e.toString());
        setState(() {
          loading = true;
        });
      },
      codeSent: (verificationId, forceResendingToken) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerificationScreen(verificationId: verificationId),
          ),
          (route) => false,
        );
        setState(() {
          loading = true;
        });
      },
      codeAutoRetrievalTimeout: (e) {
        Utils.showToast(context, e.toString());
        setState(() {
          loading = true;
        });
      },
    );
  }
}
