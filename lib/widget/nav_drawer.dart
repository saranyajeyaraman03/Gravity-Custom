import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/auth/authhelper.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/main.dart';
import 'package:gravitycustom/screen/login.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150.dynamic,
            decoration:const BoxDecoration(
              color: ConstantColor.dartBlue
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Gravity Custom",
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 30.dynamic),
                  ),
                  ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Welcome",
                  style: GoogleFonts.montserrat(fontSize: 16.dynamic, color: Colors.black),
                ),
                SizedBox(
                  width: 10.dynamic,
                ),
                Text(
                  "Saranya.J",
                  style: GoogleFonts.montserrat(
                      fontSize: 18.dynamic,
                      color: ConstantColor.dartBlue,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'Profile',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Get.toNamed(NavPage.profile);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.password,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'Change Password',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Get.toNamed(NavPage.changePassword);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'My Cars',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'Orders',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.subscriptions_sharp,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'Subscriptions',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.messenger_outline_rounded,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'FAQs',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.menu_book_outlined,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'Terms & Conditions',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.lock,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'Privacy Policy',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_rounded,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'About Us',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 25.dynamic,
              color: Colors.black,
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: Colors.black,
                letterSpacing: 0,
              ),
            ),
            onTap: () {
              showCupertinoDialog(
                  context: context,
                  builder: (_) {
                    return CupertinoAlertDialog(
                      title: Text('Confirmation',
                          style: GoogleFonts.montserrat(fontSize: 18.dynamic)),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: GoogleFonts.montserrat(fontSize: 16.dynamic),
                      ),
                      actions: [
                        CupertinoButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CupertinoButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            AuthHelper authHelper =
                                Provider.of<AuthHelper>(context, listen: false);
                            authHelper.setLoggedIn(false);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
