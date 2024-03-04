// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/services/remote_service.dart';
import 'package:gravitycustom/widget/snackbar.dart';
import 'package:http/http.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isPasswordVisible = false;

  String? _phoneCode;

  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _phoneNumberError;

  void _validateFields() {
    setState(() {
      _firstNameError = _validateName(_firstNameController.text, 'First Name');
      _lastNameError = _validateName(_lastNameController.text, 'Last Name');
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);

      _phoneNumberError = _validatePhoneNumber(_phoneNumberController.text);
      _phoneCode ?? "+91";
      if (_firstNameError == null &&
          _lastNameError == null &&
          _emailError == null &&
          _passwordError == null &&
          _phoneNumberError == null) {
        signUpApi(
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          "${_phoneCode!} ${_phoneNumberController.text}",
          _passwordController.text,
        );
       // verfiyMail(_emailController.text);
      }
    });
  }

  String? _validateName(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
  }

  Future<void> signUpApi(String fName, String lName, String email,
      String mobileNo, String password) async {
    try {
      Response response = await RemoteServices.userSignUp(
          fName, lName, email, mobileNo, password);
      print(response.statusCode);
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);

        if (data.containsKey("success")) {
          String successMessage = data["success"];
          SnackbarHelper.showSnackBar("Success", successMessage);

          Navigator.pop(context);
        } else {
          print("Unexpected response format: $data");
        }
      } else {
        var data = jsonDecode(response.body);

        if (data.containsKey("phone_number")) {
          String phoneNumberError = data["phone_number"][0];
          SnackbarHelper.showSnackBar("Phone Number Error:", phoneNumberError);
        } else if (data.containsKey("email")) {
          String emailError = data["email"][0];
          SnackbarHelper.showSnackBar("Email Error:", emailError);
        } else {
          SnackbarHelper.showSnackBar(
              "Registration failed!", "Please try again!");
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> verfiyMail(String email) async {
    try {
      Response response = await RemoteServices.verifyMail(email);
      print(response.statusCode);
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);

        if (data.containsKey("success")) {
          String successMessage = data["success"];
          SnackbarHelper.showSnackBar("Success", successMessage);
          Navigator.pop(context);
        } else {
          print("Unexpected response format: $data");
        }
      } else {
        SnackbarHelper.showSnackBar(
            "Error", "Verify email failed! Please try again!");
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.dynamic),
        child: Column(
          children: [
            SizedBox(height: 60.dynamic),
            Text(
              "Sign up",
              style: GoogleFonts.montserrat(
                fontSize: 30.dynamic,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.dynamic,
            ),
            Text(
              "Create your account",
              style: GoogleFonts.montserrat(fontSize: 15.dynamic, color: Colors.grey[700]),
            ),
            SizedBox(
              height: 20.dynamic,
            ),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: "First Name",
                errorText: _firstNameError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: ConstantColor.mediumBlue.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.dynamic),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: "Last Name",
                errorText: _lastNameError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: ConstantColor.mediumBlue.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.dynamic),
            IntlPhoneField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                errorText: _phoneNumberError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: ConstantColor.mediumBlue.withOpacity(0.1),
                filled: true,
              ),
              keyboardType: TextInputType.phone,
              initialCountryCode: 'IN',
              onChanged: (phone) {
                _phoneCode = phone.countryCode;
                print(phone.completeNumber);
              },
            ),
            SizedBox(height: 10.dynamic),
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
            Container(
              padding: const EdgeInsets.only(top: 3, left: 3),
              width: MediaQuery.of(context).size.width - 200,
              child: ElevatedButton(
                onPressed: _validateFields,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  primary: ConstantColor.mediumBlue,
                ),
                child: Text(
                  "Sign up",
                  style: GoogleFonts.montserrat(fontSize: 20.dynamic, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20.dynamic),
            Center(
              child: Text(
                "Or",
                style: GoogleFonts.montserrat(fontSize: 16.dynamic, color: Colors.black),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Already have an account?",
                  style: GoogleFonts.montserrat(fontSize: 16.dynamic),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Login",
                    style: GoogleFonts.montserrat(
                      fontSize: 18.dynamic,
                      color: ConstantColor.mediumBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
