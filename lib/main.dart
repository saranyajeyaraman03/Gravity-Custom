import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/auth/authhelper.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/controller/app_controller.dart';
import 'package:gravitycustom/screen/addcar/addcar_screen.dart';
import 'package:gravitycustom/screen/addcar/cartype_screen.dart';
import 'package:gravitycustom/screen/addcar/year_screen.dart';
import 'package:gravitycustom/screen/login.dart';
import 'package:gravitycustom/screen/menu/change_password.dart';
import 'package:gravitycustom/screen/menu/mycar.dart';
import 'package:gravitycustom/screen/profile/profile_helper.dart';
import 'package:gravitycustom/screen/profile/profile_screen.dart';
import 'package:gravitycustom/screen/splash_screen.dart';
import 'package:provider/provider.dart';

class NavPage {
  static String root = "/";
  static String changePassword = '/changepassword';
  static String profile = '/profile';
  //static String addCar = '/addcar';
  //static String selectCarType = '/selectcartype';
  //static String selectCarYear = '/selectcarYear';
  static String myCar = '/mycar';
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthHelper()),
        ChangeNotifierProvider(create: (_) => ProfileHelper()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(
          name: '/',
          page: () {
            return GetBuilder<AppController>(
              builder: (controller) {
                return controller.rootView();
              },
            );
          },
        ),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(
            name: NavPage.changePassword,
            page: () => const ChangePasswordScreen()),
        GetPage(name: NavPage.profile, page: () => const ProfileScreen()),
        // GetPage(
        //     name: NavPage.selectCarType,
        //     page: () => const SelectCarTypeScreen()),
        // GetPage(
        //     name: NavPage.selectCarYear, page: () => const SelectYearScreen()),
        GetPage(name: NavPage.myCar, page: () => const MyCarScreen()),
      ],
      theme: ThemeData(
        primaryColor: ConstantColor.dartBlue,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: NavPage.root,
      home: SplashScreen(),
    );
  }
}
