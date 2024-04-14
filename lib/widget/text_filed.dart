import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/dynamic_font.dart';

class CommonTextFiled extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final TextEditingController? controller;

  const CommonTextFiled({
    Key? key,
    this.hintText = '',
    this.iconData = Icons.add_photo_alternate,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 5.0, right: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.dynamic), 
      ),
      child: TextFormField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.poppins(
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Container(
            width: 80.dynamic,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  color: Colors.black45,
                  size: 25.0,
                ),
                SizedBox(width: 20.dynamic),
                Container(
                  height: 20.0,
                  width: 1.0,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: MediaQuery.of(context).size.width * 0.042,
          ),
        ),
      ),
    );
  }
}
