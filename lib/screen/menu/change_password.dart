// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/auth/shared_preference_helper.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/services/remote_service.dart';
import 'package:gravitycustom/widget/snackbar.dart';
import 'package:http/http.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String? _passwordError;
  String? _confirmError;

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  void _validateFields() {
    setState(() {
      _passwordError = null;
      _confirmError = null;
    });

    String password = _passwordController.text;
    String confirm = _confirmController.text;

    if (password.isEmpty) {
      setState(() {
        _passwordError = "Password is required";
      });
    }

    if (confirm.isEmpty) {
      setState(() {
        _confirmError = "Confirm Password is required";
      });
    }

    if (password.isNotEmpty && password.length < 6) {
      setState(() {
        _passwordError = "Password must be at least 6 characters long";
      });
    }

    if (confirm.isNotEmpty && confirm != password) {
      setState(() {
        _confirmError = "Passwords do not match";
      });
    }

    if (_passwordError == null && _confirmError == null) {
      _changePassword();
    }
  }

  Future<void> _changePassword() async {
    String password = _passwordController.text;
    String? token = await SharedPreferencesHelper.instance.getToken();
    print(token);
    try {
      Response response = await RemoteServices.changePassword(token!, password);
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
      backgroundColor: ConstantColor.profileBg,
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: GoogleFonts.montserrat(
              fontSize: 26.dynamic,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: ConstantColor.profileBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: GestureDetector(
      //     onTap: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: Text(
      //       'Change Password',
      //       style: GoogleFonts.montserrat(
      //           fontSize: 20.dynamic,
      //           color: ConstantColor.dartBlue,
      //           fontWeight: FontWeight.bold),
      //     ),
      //   ),
      //   leading: Builder(
      //     builder: (BuildContext context) {
      //       return IconButton(
      //         icon: Icon(
      //           Icons.arrow_back_ios,
      //           size: 25.dynamic,
      //           color: ConstantColor.dartBlue,
      //         ),
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //       );
      //     },
      //   ),
      //   titleSpacing: -20, // Adjust this value as needed
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/gravity_logo.png',
                  ),
                ),
                SizedBox(
                  height: 40.dynamic,
                ),
                
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "New Password",
                    errorText: _passwordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: ConstantColor.mediumBlue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                SizedBox(
                  height: 20.dynamic,
                ),
                TextField(
                  controller: _confirmController,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    errorText: _confirmError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: ConstantColor.mediumBlue.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmVisible = !_isConfirmVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                SizedBox(height: 40.dynamic),
                // Container(
                //   height: 50.dynamic,
                //   width: MediaQuery.of(context).size.width - 200.dynamic,
                //   child: Material(
                //     borderRadius: BorderRadius.circular(20.0),
                //     shadowColor: Colors.blueAccent,
                //     color: Colors.blue,
                //     elevation: 7.0,
                //     child: GestureDetector(
                //         onTap: () {
                //           _validateFields();
                //         },
                //         child: Center(
                //             child: Text(
                //           'Change Password',
                //           style: GoogleFonts.montserrat(
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //               fontSize: 16.dynamic),
                //         ))),
                //   ),
                // ),

                ElevatedButton(
                  onPressed: () {
                    _validateFields();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: ConstantColor.dartBlue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.dynamic),
                        child: Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.dynamic,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.dynamic),
                        child: Container(
                          width: 70.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: ConstantColor.dartBlue,
                            size: 25.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15.dynamic),
        ],
      ),
    );
  }
}
