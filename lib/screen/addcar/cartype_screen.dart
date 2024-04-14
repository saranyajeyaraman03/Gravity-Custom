// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/common/constant.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/main.dart';
import 'package:gravitycustom/screen/addcar/addcar_screen.dart';
import 'package:gravitycustom/screen/menu/mycar.dart';

class SelectCarTypeScreen extends StatefulWidget {
  final bool homeStatus;
  const SelectCarTypeScreen({super.key, required this.homeStatus});

  @override
  _SelectCarTypeScreenState createState() => _SelectCarTypeScreenState();
}

class _SelectCarTypeScreenState extends State<SelectCarTypeScreen> {
  final List<Map<String, dynamic>> carTypes = [
    {'name': 'SUV', 'icon': Icons.directions_car},
    {'name': 'MUV', 'icon': Icons.directions_car},
    {'name': 'SEDAN', 'icon': Icons.directions_car},
    {'name': 'HATCHBACK', 'icon': Icons.directions_car},
    {'name': 'COUP', 'icon': Icons.directions_car},
    {'name': 'TRUCK', 'icon': Icons.directions_car},
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AddCarScreen(
                    homeStatus: widget.homeStatus,
                  )),
          (route) => false,
        );

          return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ConstantColor.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.dynamic,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.dynamic, vertical: 20.dynamic),
                  child: Text(
                    'Select Car Type',
                    style: TextStyle(
                      fontSize: 20.dynamic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.dynamic, vertical: 20.dynamic),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 24.dynamic,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCarScreen(
                                    homeStatus: widget.homeStatus,
                                  )),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.dynamic, vertical: 20.dynamic),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: carTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(carTypes[index]['icon']),
                    title: Text(carTypes[index]['name']),
                    onTap: () {
                      Constants.selectedCarType.value = carTypes[index]['name'];
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCarScreen(
                                  homeStatus: widget.homeStatus,
                                )),
                        (route) => false,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
