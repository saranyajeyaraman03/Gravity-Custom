// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:gravitycustom/auth/authhelper.dart';
import 'package:gravitycustom/auth/shared_preference_helper.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/screen/home_screen.dart';
import 'package:gravitycustom/screen/resetpassword.dart';
import 'package:gravitycustom/screen/signup_screen.dart';
import 'package:gravitycustom/services/remote_service.dart';
import 'package:gravitycustom/widget/snackbar.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _emailError = '';
  String _passwordError = '';

  void _validateFields() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);

      if (_emailError.isEmpty && _passwordError.isEmpty) {
        // If no validation errors, proceed with login
        _performLogin();
      }
    });
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return '';
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    return '';
  }

  _performLogin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      Response response = await RemoteServices.login(email, password);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String accessToken = data["data"]["auth_token"];

        await SharedPreferencesHelper.instance.setToken(
          accessToken,
        );

        if (data.containsKey("Success")) {
          String successMessage = data["Success"];
          AuthHelper authHelper =
              Provider.of<AuthHelper>(context, listen: false);
          authHelper.setLoggedIn(true);

          SnackbarHelper.showSnackBar("Login Success", successMessage);
          Get.offAll(
            () => HomeScreen(),
            predicate: (route) => false,
          );
        } else {
          print("Unexpected response format: $data");
        }
      } else {
        var data = jsonDecode(response.body);

        if (data.containsKey("error")) {
          String errorMsg = data["error"];
          SnackbarHelper.showSnackBar("error", errorMsg);
        } else {
          SnackbarHelper.showSnackBar(
              "error", "Login failed! Please try again!");
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              ConstantColor.dartBlue,
              ConstantColor.dartBlue.withOpacity(0.8),
              ConstantColor.dartBlue.withOpacity(0.6),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 80.dynamic,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Gravity Custom",
                    style: GoogleFonts.montserrat(
                        color: Colors.white, fontSize: 40.dynamic),
                  ),
                  SizedBox(
                    height: 10.dynamic,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.dynamic),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30.dynamic,
                        ),
                        Text(
                          "Login",
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 26.dynamic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30.dynamic,
                        ),

                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorText: _emailError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor:
                                ConstantColor.mediumBlue.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 20.dynamic),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorText: _passwordError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor:
                                ConstantColor.mediumBlue.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(10),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: ConstantColor.dartBlue.withOpacity(0.4),
                        //         blurRadius: 20,
                        //         offset: const Offset(0, 10),
                        //       ),
                        //     ],
                        //   ),
                        //   child: Column(
                        //     children: <Widget>[
                        //       Container(
                        //         padding: const EdgeInsets.all(10),
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             bottom: BorderSide(color: Colors.grey),
                        //           ),
                        //         ),
                        //         child: const TextField(
                        //           decoration: InputDecoration(
                        //             hintText: "Email ",
                        //             hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                        //             border: InputBorder.none,
                        //             prefixIcon: Icon(
                        //               Icons.mail_outline,
                        //               color: Colors.grey,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       Container(
                        //         padding: const EdgeInsets.all(10),
                        //         decoration: const BoxDecoration(
                        //           border: Border(
                        //             bottom: BorderSide(color: Colors.grey),
                        //           ),
                        //         ),
                        //         child: TextField(
                        //           obscureText: !_isPasswordVisible,
                        //           decoration: InputDecoration(
                        //             hintText: "Password",
                        //             hintStyle:
                        //                 const GoogleFonts.montserrat(color: Colors.grey),
                        //             border: InputBorder.none,
                        //             prefixIcon: const Icon(
                        //               Icons.lock,
                        //               color: Colors.grey,
                        //             ),
                        //             suffixIcon: IconButton(
                        //               icon: Icon(
                        //                 _isPasswordVisible
                        //                     ? Icons.visibility
                        //                     : Icons.visibility_off,
                        //                 color: Colors.grey,
                        //               ),
                        //               onPressed: () {
                        //                 setState(() {
                        //                   _isPasswordVisible =
                        //                       !_isPasswordVisible;
                        //                 });
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                          height: 40.dynamic,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ResetPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.montserrat(
                                color: ConstantColor.mediumBlue,
                                fontSize: 14.dynamic,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.dynamic,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Does not have account?',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16.dynamic)),
                            TextButton(
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.montserrat(
                                    fontSize: 18.dynamic,
                                    color: ConstantColor.mediumBlue),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 40.dynamic,
                        ),
                        Container(
                          height: 50.dynamic,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ConstantColor.mediumBlue,
                          ),
                          child: ElevatedButton(
                            onPressed: _validateFields,
                            style: ElevatedButton.styleFrom(
                              primary: ConstantColor.mediumBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 18.dynamic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 50.dynamic,
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
    );
  }
}
