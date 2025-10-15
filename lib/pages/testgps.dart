import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer';

import 'package:latlong2/latlong.dart';

class Testgps extends StatefulWidget {
  const Testgps({super.key});

  @override
  State<Testgps> createState() => _TestgpsState();
}

class _TestgpsState extends State<Testgps> {
  var mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPS and Map')),
      body: Center(
        child: Column(
          children: [
            FilledButton(
            onPressed: () async {
             var position = await _determinePosition();
             log("${position.latitude} ${position.longitude}");
             var latLng = LatLng(position.latitude , position.longitude);
             mapController.move(latLng, 15);
            }, 
            child: Text('Get GPS')
            ),
            Expanded(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: LatLng(16.246373, 103.251827),
                  initialZoom: 15.2,
                  onTap: (tapPosition, point) {
                    log(point.toString());
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=32669ee754b64d6a84b26eedd7d1fc8a',
                    userAgentPackageName: 'com.example.delivery',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(16.246373, 103.251827),
                        child: Icon(Icons.location_on, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
 

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
}