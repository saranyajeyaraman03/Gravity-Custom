// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gravitycustom/auth/shared_preference_helper.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/common/constant.dart';
import 'package:gravitycustom/common/location.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/main.dart';
import 'package:gravitycustom/model/car_model.dart';
import 'package:gravitycustom/screen/addcar/addcar_screen.dart';
import 'package:gravitycustom/services/remote_service.dart';
import 'package:gravitycustom/widget/nav_drawer.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late GoogleMapController googleMapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  late String currentAddress = "";
  List<dynamic> allServices = [];
  late List<Car> cars = [];

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    _initCurrentLocation();
  }

  Set<Marker> markers = {};

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
          if (cars.isNotEmpty) {
            fetchCarCategory();
          }
        });
      } else {
        throw Exception('Failed to fetch cars');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _initCurrentLocation() async {
    try {
      Position position = await LocationService.determinePosition();
      _updateMap(position);
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _updateMap(Position position) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
      ),
    );

    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'Your Location'),
      ),
    );
    getLocationFromCoordinates(position.latitude, position.longitude);
    setState(() {});
  }

  Future<void> getLocationFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        setState(() {
          currentAddress = [
            placemark.subLocality,
            placemark.locality,
            placemark.administrativeArea,
            placemark.country,
          ].where((part) => part != null && part.isNotEmpty).join(', ');

          print('Address: $currentAddress');
        });
      } else {
        print('No location found for the provided coordinates.');
      }
    } catch (e) {
      print('Error getting location from coordinates: $e');
    }
  }

  Future<void> fetchCarCategory() async {
    String? token = await SharedPreferencesHelper.instance.getToken();

    try {
      var response = await RemoteServices.fetchCarCategory(token!);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          allServices = data['categories'];
        });
        print('Fetched services: ${allServices.length}');
      } else {
        throw Exception('Failed to fetch services');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.transparentColor,
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                  ),
                  markers: markers,
                  zoomControlsEnabled: true,
                ),
                Positioned(
                  top: 32,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: ConstantColor.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Address Details:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    currentAddress,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  // Add more address details here if needed
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              currentAddress,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: ConstantColor.transparentColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cars.isNotEmpty
                            ? Row(
                                children: [
                                  Icon(Icons.directions_car, size: 48.dynamic),
                                  SizedBox(width: 8.dynamic),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${cars.last.carBrand} - ${cars.last.carType}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 14.dynamic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        cars.last.carModelYear,
                                        style: TextStyle(
                                            fontSize: 14.dynamic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(
                                child: Row(
                                children: [
                                  Icon(Icons.directions_car, size: 48.dynamic),
                                  SizedBox(width: 8.dynamic),
                                  Text(
                                    "NO CAR ADDED",
                                    style: TextStyle(
                                        fontSize: 12.dynamic,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        Container(
                          margin: const EdgeInsets.only(
                              right: 10, top: 10, bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Constants.selectedCarType.value = "";
                              Constants.selectedYear.value = "";
                              Constants.selectedCar.value = "";
                              Constants.carModelId = 0;
                              Constants.selectedCarModel.value = "";
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddCarScreen(
                                          homeStatus: true,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.yellow,
                            ),
                            child: Text(
                              'ADD CAR',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.dynamic, top: 20.dynamic),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Explore Popular Services',
                        style: GoogleFonts.poppins(
                          fontSize: 18.dynamic,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.dynamic),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: allServices.length,
                        itemBuilder: (BuildContext context, int index) {
                          var service = allServices[index];
                          if (service != null &&
                              service['category_image'] != null &&
                              service['category_name'] != null) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 80,
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Image.network(
                                      RemoteServices.bookingUrl +
                                          service['category_image'],
                                      fit: BoxFit.fill,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        service['category_name'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.dynamic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Handle null or invalid data
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
