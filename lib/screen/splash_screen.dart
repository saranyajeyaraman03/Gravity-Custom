import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gravitycustom/auth/authhelper.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/screen/home_screen.dart';
import 'package:gravitycustom/screen/login.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      AuthHelper authHelper = Provider.of<AuthHelper>(context, listen: false);
      await authHelper.loadLoggedInState();

      print(authHelper.isLoggedIn);

      Timer(
        const Duration(seconds: 5),
        () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Consumer<AuthHelper>(
                builder: (context, authHelper, child) {
                  return authHelper.isLoggedIn ? HomeScreen() : LoginScreen();
                },
              ),
            ),
          );
        },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.dartBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/garvity_white_logo.png',
            ),
          ],
        ),
      ),
    );
  }
}
