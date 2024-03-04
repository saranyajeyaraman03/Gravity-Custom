import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/screen/login.dart';

enum LoginStatus { logged, logout, loading }

class AppController extends GetxController {
  var loginStatus = LoginStatus.loading.obs;

    Widget rootView() {
    switch (loginStatus.value) {
      case LoginStatus.logged:
        return Container();
      case LoginStatus.logout:
        return LoginScreen();
      case LoginStatus.loading:
        return Scaffold(
          body: Container(
            child: Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 20.dynamic,
                ),
              ),
            ),
          ),
        );
    }
  }
}
