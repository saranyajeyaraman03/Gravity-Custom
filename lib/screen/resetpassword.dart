// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/services/remote_service.dart';
import 'package:gravitycustom/widget/snackbar.dart';
import 'package:http/http.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  void _validateFields() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      if (_emailController.text.isNotEmpty) {
        _resetPassword();
      }
    });
  }

  Future<void> _resetPassword() async {
    String email = _emailController.text;

    try {
      Response response = await RemoteServices.resetPassword(email);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data.containsKey("detail")) {
          String successMessage = data["detail"];
          SnackbarHelper.showSnackBar("Success", successMessage);

          Navigator.pop(context);
        } else {
          print("Unexpected response format: $data");
        }
      } else {
        var data = jsonDecode(response.body);

        if (data.containsKey("non_field_errors")) {
          String errorMsg = data["non_field_errors"][0];
          SnackbarHelper.showSnackBar("error", errorMsg);
        } else {
          SnackbarHelper.showSnackBar(
              "error", "Reset Password failed! Please try again!");
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 0.0),
                  child: Text('Reset',
                      style: GoogleFonts.poppins(
                          fontSize: 50.dynamic, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 100.0, 0.0, 0.0),
                  child: Text('Password?',
                      style: GoogleFonts.poppins(
                          fontSize: 50.dynamic, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Enter the email address associated with your account.',
                  style: GoogleFonts.poppins(
                      fontSize: 20.dynamic,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
                SizedBox(height: 20.dynamic),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    errorText: _emailError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: ConstantColor.mediumBlue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 40.dynamic),
                Container(
                  height: 50.dynamic,
                  width: MediaQuery.of(context).size.width - 200.dynamic,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.blueAccent,
                    color: Colors.blue,
                    elevation: 7.0,
                    child: GestureDetector(
                        onTap: () {
                          _validateFields();
                        },
                        child: Center(
                            child: Text(
                          'Reset Password',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.dynamic),
                        ))),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.dynamic),
        ],
      ),
    );
  }
}
