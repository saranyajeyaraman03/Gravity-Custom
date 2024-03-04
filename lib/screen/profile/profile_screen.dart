import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/widget/text_filed.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _fnameController =
      TextEditingController(text: "Saranya");
  TextEditingController _lnameController =
      TextEditingController(text: "Jeyaraman");
  TextEditingController _emailController =
      TextEditingController(text: "saranyamadhan03@gmail.com");
  TextEditingController _phoneController =
      TextEditingController(text: "+91 9965056147");

  @override
  void initState() {
    super.initState();
    _fnameController = TextEditingController(text: "Saranya");
    _lnameController = TextEditingController(text: "Jeyaraman");
    _emailController = TextEditingController(text: "saranyamadhan03@gmail.com");
    _phoneController = TextEditingController(text: "+91 9965056147");
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.profileBg,
      appBar: AppBar(
        title: Text(
          'Profile',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name Field
            Text(
              "First Name",
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: ConstantColor.dartBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10.dynamic,
            ),

            CommonTextFiled(
              controller: _fnameController,
              iconData: Icons.person,
            ),
            const SizedBox(height: 16),

            Text(
              "Last Name",
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: ConstantColor.dartBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10.dynamic,
            ),

            CommonTextFiled(
              controller: _lnameController,
              iconData: Icons.person,
            ),
            const SizedBox(height: 16),

            Text(
              "Email",
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: ConstantColor.dartBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10.dynamic,
            ),

            CommonTextFiled(
              controller: _emailController,
              iconData: Icons.email,
            ),
            const SizedBox(height: 16),
            Text(
              "Phone Number",
              style: GoogleFonts.montserrat(
                fontSize: 18.dynamic,
                color: ConstantColor.dartBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10.dynamic,
            ),

            CommonTextFiled(
              controller: _phoneController,
              iconData: Icons.phone,
            ),

             SizedBox(height:30.dynamic),

            ElevatedButton(
              onPressed: () {
                // Handle button press
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gravitycustom/common/colors.dart';
// import 'package:gravitycustom/dynamic_font.dart';
// import 'package:gravitycustom/screen/profile/profile_helper.dart';
// import 'package:provider/provider.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Profile',
//           style: GoogleFonts.montserrat(
//             fontSize: 20.dynamic,
//             fontWeight: FontWeight.bold,
//             color: ConstantColor.white,
//           ),
//         ),
//         backgroundColor: ConstantColor.dartBlue,
//         titleSpacing: -20,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: ConstantColor.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           const Expanded(flex: 2, child: _TopPortion()),
//           Expanded(
//             flex: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Text(
//                     "Edit Profile",
//                     style: GoogleFonts.montserrat(
//                       fontSize: 20.dynamic,
//                       color: ConstantColor.dartBlue,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 10,
//                     color: const Color(0xFFF2F2F2),
//                   ),
//                   Provider.of<ProfileHelper>(context, listen: false).section(
//                     "First Name",
//                     'Saranya ',
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 10,
//                     color: const Color(0xFFF2F2F2),
//                   ),
//                   Provider.of<ProfileHelper>(context, listen: false).section(
//                     "Last Name",
//                     'J ',
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 10,
//                     color: const Color(0xFFF2F2F2),
//                   ),
//                   Provider.of<ProfileHelper>(context, listen: false).section(
//                     "Email",
//                     'Saranyamadhan03@gmail.com',
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 10,
//                     color: const Color(0xFFF2F2F2),
//                   ),
//                   Provider.of<ProfileHelper>(context, listen: false).section(
//                     "Phone Number",
//                     ' +91 9965056147',
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 10,
//                     color: const Color(0xFFF2F2F2),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TopPortion extends StatelessWidget {
//   const _TopPortion({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Container(
//           margin: const EdgeInsets.only(bottom: 50),
//           decoration:  BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [ConstantColor.dartBlue, ConstantColor.dartBlue.withOpacity(1)]),
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(50),
//                 bottomRight: Radius.circular(50),
//               )),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: SizedBox(
//             width: 120,
//             height: 120,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                       border:
//                           Border.all(color: ConstantColor.dartBlue, width: 4),
//                     ),
//                     child: Center(
//                       child: Container(
//                         width: 80,
//                         height: 80,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                             image: AssetImage('assets/user_icon.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     )),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                     child: Container(
//                       margin: const EdgeInsets.all(10.0),
//                       decoration: const BoxDecoration(
//                           color: ConstantColor.dartBlue,
//                           shape: BoxShape.circle),
//                       child: const Icon(
//                         Icons.edit,
//                         color: ConstantColor.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
