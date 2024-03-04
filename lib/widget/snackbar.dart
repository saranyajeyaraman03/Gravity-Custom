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
        style: GoogleFonts.montserrat(
          fontSize: 20.dynamic,
          fontWeight: FontWeight.bold,
          color: ConstantColor.dartBlue,
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.montserrat(fontSize: 16.dynamic),
      ),
    );
  }
}
