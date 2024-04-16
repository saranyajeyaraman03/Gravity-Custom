// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gravitycustom/common/colors.dart';
import 'package:gravitycustom/common/location.dart';
import 'package:gravitycustom/dynamic_font.dart';
import 'package:gravitycustom/model/car_model.dart';
import 'package:gravitycustom/widget/nav_drawer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';

class SelectServiceScreen extends StatefulWidget {
  @override
  _SelectServiceScreenState createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late GoogleMapController googleMapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  late String currentAddress = "";
  List<dynamic> allServices = [];
  late List<Car> cars = [];
  var logger = Logger();

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    _initCurrentLocation();
  }

  Set<Marker> markers = {};

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
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              color: ConstantColor.transparentColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.dynamic,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20.dynamic,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 50.dynamic,
                      ),
                      Text(
                        'Select Service',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
