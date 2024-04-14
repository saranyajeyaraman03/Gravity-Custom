import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/dynamic_font.dart';

class SnackbarHelper {
  
  static void showSnackBar(String title,String message) {
    Get.snackbar(
      "",
      message,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20.dynamic,
          fontWeight: FontWeight.bold,
          color: ConstantColor.dartBlue,
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.poppins(fontSize: 16.dynamic),
      ),
    );
  }

   static void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Done',
        textColor: Colors.white,
        onPressed: () {
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


