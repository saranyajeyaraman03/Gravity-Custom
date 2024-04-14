import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gravitycustom/auth/shared_preference_helper.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/main.dart';
import 'package:gravitycustom/model/car_model.dart';
import 'package:gravitycustom/screen/addcar/addcar_screen.dart';
import 'package:gravitycustom/services/remote_service.dart';

class MyCarScreen extends StatefulWidget {
  const MyCarScreen({Key? key}) : super(key: key);

  @override
  _MyCarScreenState createState() => _MyCarScreenState();
}

class _MyCarScreenState extends State<MyCarScreen> {
  late List<Car> cars = [];

  @override
  void initState() {
    super.initState();
    fetchCar();
  }

  Future<void> fetchCar() async {
    try {
      String? token = await SharedPreferencesHelper.instance.getToken();
      var response = await RemoteServices.fetchCars(token!);
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          cars = jsonData.map((json) => Car.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to fetch cars');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      String? token = await SharedPreferencesHelper.instance.getToken();
      var response = await RemoteServices.deleteCars(token!, carId);
      print(response.statusCode);
      if (response.statusCode == 204) {
        fetchCar();
      } else {
        throw Exception('Failed to fetch cars');
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.transparentColor,
      appBar: AppBar(
        backgroundColor: ConstantColor.transparentColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'My Car',
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 22.0),
        ),
      ),
      body: cars.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48.dynamic,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.dynamic),
                  Text(
                    'No vehicles added',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.dynamic,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: Image.network(
                        'https://gravitycustoms.net/media/service_img/a81c5298-f2f4-4750-bc88-7914804efe2e.png'),
                    title: Text('${car.carBrand} - ${car.carType}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(car.carModel),
                        Text(car.carModelYear),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        deleteCar(car.id);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ConstantColor.dartBlue,
        foregroundColor: Colors.white,
        shape: CircleBorder(eccentricity: 1.dynamic),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AddCarScreen(homeStatus: false,)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
