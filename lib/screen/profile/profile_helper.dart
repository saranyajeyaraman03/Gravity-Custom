import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/dynamic_font.dart';

class ProfileHelper extends ChangeNotifier {
  Widget section(String title, String data) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18.dynamic,
                      color: ConstantColor.dartBlue,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    data,
                    style: GoogleFonts.montserrat(
                      fontSize: 16.dynamic,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}