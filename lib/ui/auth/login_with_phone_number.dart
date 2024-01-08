import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_features/ui/auth/verify_code.dart';
import 'package:firebase_features/utils/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  final phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                debugPrint(number.phoneNumber);
                              },
                              onInputValidated: (bool value) {
                                debugPrint(value.toString());
                              },
                              selectorConfig: const SelectorConfig(
                                selectorType: PhoneInputSelectorType.DROPDOWN,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle:
                                  const TextStyle(color: Colors.white),
                              initialValue: number,
                              textFieldController: phoneNumberController,
                              inputDecoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                              validator: (mobileNumber) =>
                                  validatePhoneNumber(mobileNumber ?? '')),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              auth.verifyPhoneNumber(
                                phoneNumber: phoneNumberController.text,
                                verificationCompleted: (_) {},
                                verificationFailed: (e) {
                                  Utils.showToast(context, e.toString());
                                },
                                codeSent: (String verificationId, int? token) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const VerificationScreen(),
                                      ));
                                },
                                codeAutoRetrievalTimeout: (e) {
                                  Utils.showToast(context, e.toString());
                                },
                              );
                              // _formKey.currentState?.validate();
                              // Utils.showToast(context, number.toString());
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    }

    if (value.length < 10) {
      return 'Enter a valid phone number';
    }

    return null;
  }
}
