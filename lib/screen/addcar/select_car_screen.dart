// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/common/constant.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/screen/addcar/addcar_screen.dart';
import 'package:gravitycustom/services/remote_service.dart';

class Car {
  final int id;
  final String name;

  Car(this.id, this.name);
}

class SelectCarScreen extends StatefulWidget {
  final String jwtToken;
  final bool homeStatus;
  const SelectCarScreen(
      {Key? key, required this.jwtToken, required this.homeStatus})
      : super(key: key);

  @override
  _SelectCarScreenState createState() => _SelectCarScreenState();
}

class _SelectCarScreenState extends State<SelectCarScreen> {
  late Future<List<Car>> _carNamesFuture;

  @override
  void initState() {
    super.initState();
    _carNamesFuture = _fetchCarNames(
        widget.jwtToken, int.parse(Constants.selectedYear.value));
  }

  Future<List<Car>> _fetchCarNames(String jwtToken, int year) async {
    try {
      var response = await RemoteServices.getCarNames(jwtToken, year);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body)['data'];
        List<Car> cars = [];
        for (var item in jsonResponse) {
          cars.add(Car(item['id'], item['name']));
        }
        return cars;
      } else {
        throw Exception('Failed to load car names');
      }
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
                    'Select Car',
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
              child: FutureBuilder<List<Car>>(
                future: _carNamesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.directions_car),
                          title: Text(snapshot.data![index].name),
                          onTap: () {
                            Constants.selectedCar.value =
                                snapshot.data![index].name;
                            Constants.carModelId = snapshot.data![index].id;
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
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
