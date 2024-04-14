import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/common/constant.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/screen/addcar/addcar_screen.dart';
import 'package:gravitycustom/services/remote_service.dart';

class SelectYearScreen extends StatefulWidget {
  final bool homeStatus;
  const SelectYearScreen({Key? key, required this.homeStatus})
      : super(key: key);

  @override
  SelectYearScreenState createState() => SelectYearScreenState();
}

class SelectYearScreenState extends State<SelectYearScreen> {
  String jwtToken = '';
  int? selectedCarYear;
  List<int> carBuildYears = [];
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _carApi(); // Call API when the widget initializes
  }

  Future<void> _carApi() async {
    try {
      if (!_isLoading) return;
      setState(() {
        _isLoading = true;
      });
      var response = await RemoteServices.performCarLogin();
      print(response.body);
      setState(() {
        jwtToken = response.body;
      });
      await getCarBuildYears();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  Future<void> getCarBuildYears() async {
    try {
      var response = await RemoteServices.getCarBuildYears(jwtToken);
      List<dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      setState(() {
        carBuildYears = jsonResponse.cast<int>();
      });
    } catch (error) {
      rethrow;
    }
  }

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
                    'Select Year',
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: carBuildYears.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.directions_car),
                          title: Text(carBuildYears[index].toString()),
                          onTap: () {
                            Constants.selectedYear.value =
                                carBuildYears[index].toString();
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
