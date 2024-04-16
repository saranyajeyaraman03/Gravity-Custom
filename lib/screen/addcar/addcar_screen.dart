// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/auth/shared_preference_helper.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/common/constant.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/screen/addcar/cartype_screen.dart';
import 'package:gravitycustom/screen/addcar/select_car_model_screen.dart';
import 'package:gravitycustom/screen/addcar/select_car_screen.dart';
import 'package:gravitycustom/screen/addcar/year_screen.dart';
import 'package:gravitycustom/screen/home_screen.dart';
import 'package:gravitycustom/screen/menu/mycar.dart';
import 'package:gravitycustom/services/remote_service.dart';
import 'package:gravitycustom/widget/snackbar.dart';

class AddCarScreen extends StatefulWidget {
  final bool homeStatus;

  const AddCarScreen({Key? key, required this.homeStatus}) : super(key: key);
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  String jwtToken = '';

  @override
  void initState() {
    super.initState();
    _carApi();
  }

  Future<void> _carApi() async {
    try {
      var response = await RemoteServices.performCarLogin();
      print(response.body);
      if (mounted) {
        setState(() {
          jwtToken = response.body;
        });
      }
    } catch (error) {
      print('Error fetching car data: $error');
      // Handle error
    }
  }

  Future<bool> addCar() async {
    try {
      String? token = await SharedPreferencesHelper.instance.getToken();
      var response = await RemoteServices.addCar(
          token!,
          Constants.selectedCar.value,
          Constants.selectedCarModel.value,
          Constants.selectedYear.value,
          Constants.selectedCarType.value);

      if (response.statusCode == 201) {
        SnackbarHelper.showSnackBar("Sucess", 'Car added successfully.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  widget.homeStatus ? HomeScreen() : const MyCarScreen()),
        );
        setState(() {
          Constants.selectedCar.value = "";
          Constants.selectedCarModel.value = "";
          Constants.selectedYear.value = "";
          Constants.selectedCarType.value = "";
        });
        return true;
      } else {
        print('Failed to add car. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( 
      onWillPop: () async {
        print('Back button pressed');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                widget.homeStatus ? HomeScreen() : const MyCarScreen(),
          ),
        );

          return Future.value(true);
      },
    

      child: Scaffold(
        backgroundColor: ConstantColor.transparentColor,
        appBar: AppBar(
          backgroundColor: ConstantColor.transparentColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        widget.homeStatus ? HomeScreen() : const MyCarScreen()),
              );
            },
          ),
          title: Text(
            'ADD CAR',
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 22.0),
          ),
        ),
        body: Scaffold(
          backgroundColor: ConstantColor.transparentColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.dynamic,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectCarTypeScreen(
                                homeStatus: widget.homeStatus,
                              )),
                    );
                  },
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_sharp,
                          color: ConstantColor.transparentTextColor,
                          size: 24.dynamic,
                        ),
                        SizedBox(width: 8.dynamic),
                        Text(
                          '|',
                          style: TextStyle(
                            color: ConstantColor.transparentTextColor,
                            fontSize: 16.dynamic,
                          ),
                        ),
                        SizedBox(width: 12.dynamic),
                        Text(
                          Constants.selectedCarType.value.isEmpty
                              ? 'Select Car Type'
                              : Constants.selectedCarType.value,
                          style: TextStyle(
                            color: Constants.selectedCarType.value.isEmpty
                                ? ConstantColor.transparentTextColor
                                : Colors.black,
                            fontSize: 16.dynamic,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: ConstantColor.transparentTextColor,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GestureDetector(
                  onTap: Constants.selectedCarType.value.isNotEmpty
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectYearScreen(
                                      homeStatus: widget.homeStatus,
                                    )),
                          );
                        }
                      : () {
                          SnackbarHelper.showErrorSnackBar(
                              context, 'please select Car Type');
                        },
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: ConstantColor.transparentTextColor,
                          size: 24.dynamic,
                        ),
                        SizedBox(width: 8.dynamic),
                        Text(
                          '|',
                          style: TextStyle(
                            color: ConstantColor.transparentTextColor,
                            fontSize: 16.dynamic,
                          ),
                        ),
                        SizedBox(width: 12.dynamic),
                        Text(
                          Constants.selectedYear.value.isEmpty
                              ? 'Select Year'
                              : Constants.selectedYear.value,
                          style: TextStyle(
                            color: Constants.selectedYear.value.isEmpty
                                ? ConstantColor.transparentTextColor
                                : Colors.black,
                            fontSize: 16.dynamic,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: ConstantColor.transparentTextColor,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GestureDetector(
                  onTap: Constants.selectedCarType.value.isNotEmpty &&
                          Constants.selectedYear.value.isNotEmpty
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectCarScreen(
                                jwtToken: jwtToken,
                                homeStatus: widget.homeStatus,
                              ),
                            ),
                          );
                        }
                      : () {
                          String errorMessage = '';

                          if (Constants.selectedCarType.isEmpty) {
                            errorMessage = 'please select Car Type ';
                            SnackbarHelper.showErrorSnackBar(
                                context, errorMessage);

                            return;
                          }
                          if (Constants.selectedYear.isEmpty) {
                            errorMessage = 'Please select Year ';
                            SnackbarHelper.showErrorSnackBar(
                                context, errorMessage);

                            return;
                          }
                        },
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: ConstantColor.transparentTextColor,
                          size: 24.dynamic,
                        ),
                        SizedBox(width: 8.dynamic),
                        Text(
                          '|',
                          style: TextStyle(
                            color: ConstantColor.transparentTextColor,
                            fontSize: 16.dynamic,
                          ),
                        ),
                        SizedBox(width: 12.dynamic),
                        Text(
                          Constants.selectedCar.value.isEmpty
                              ? 'Select Car'
                              : Constants.selectedCar.value,
                          style: TextStyle(
                            color: Constants.selectedCar.value.isEmpty
                                ? ConstantColor.transparentTextColor
                                : Colors.black,
                            fontSize: 16.dynamic,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: ConstantColor.transparentTextColor,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    if (Constants.selectedCarType.value.isNotEmpty &&
                        Constants.selectedYear.value.isNotEmpty &&
                        Constants.selectedCar.value.isNotEmpty) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectCarModelScreen(
                            jwtToken: jwtToken,
                            homeStatus: widget.homeStatus,
                          ),
                        ),
                      );
                    } else {
                      String errorMessage = '';

                      if (Constants.selectedCarType.isEmpty) {
                        errorMessage = 'please select Car Type ';
                        SnackbarHelper.showErrorSnackBar(context, errorMessage);

                        return;
                      }
                      if (Constants.selectedYear.isEmpty) {
                        errorMessage = 'Please select Year ';
                        SnackbarHelper.showErrorSnackBar(context, errorMessage);

                        return;
                      }
                      if (Constants.selectedCar.isEmpty) {
                        errorMessage = 'Please select Car ';
                        SnackbarHelper.showErrorSnackBar(context, errorMessage);

                        return;
                      }
                    }
                  },
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: ConstantColor.transparentTextColor,
                          size: 24.dynamic,
                        ),
                        SizedBox(width: 8.dynamic),
                        Text(
                          '|',
                          style: TextStyle(
                            color: ConstantColor.transparentTextColor,
                            fontSize: 16.dynamic,
                          ),
                        ),
                        SizedBox(width: 12.dynamic),
                        Text(
                          Constants.selectedCarModel.value.isEmpty
                              ? 'Select Model'
                              : Constants.selectedCarModel.value,
                          style: TextStyle(
                            color: Constants.selectedCarModel.value.isEmpty
                                ? ConstantColor.transparentTextColor
                                : Colors.black,
                            fontSize: 16.dynamic,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: ConstantColor.transparentTextColor,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (Constants.selectedCarType.isNotEmpty &&
                          Constants.selectedYear.isNotEmpty &&
                          Constants.selectedCar.isNotEmpty &&
                          Constants.selectedCarModel.isNotEmpty) {
                        addCar();
                      } else {
                        SnackbarHelper.showErrorSnackBar(
                            context, "Please select all fileds");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantColor.dartBlue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.dynamic),
                          child: Text(
                            'Add Car',
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
