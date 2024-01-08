import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  static void showToast(BuildContext context, String message) {
    var snackbar = SnackBar(
      content: Text(
        message,
        style: GoogleFonts.montserrat(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      elevation: 20,
      showCloseIcon: true,
      closeIconColor: Colors.red,
      dismissDirection: DismissDirection.horizontal,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
