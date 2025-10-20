import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {

  GoogleMapController? _mapController;
  
  // กำหนดพิกัดเริ่มต้น
  static const LatLng _initialPosition = LatLng(13.7563, 100.5018);

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('initial_marker'),
      position: _initialPosition,
      infoWindow: InfoWindow(
        title: 'จุดเริ่มต้น',
        snippet: 'นี่คือกรุงเทพ',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Test')),
      body: GoogleMap(
   
        initialCameraPosition: const CameraPosition(
          target: _initialPosition, //zoom_position
          zoom: 14.0,          
        ),
        
        // บอกให้แผนที่ใช้ Markers ที่เราสร้างไว้
        markers: _markers, 
        
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        
        // ฟังก์ชันที่จะทำงานเมื่อผู้ใช้ 'จิ้ม' บนแผนที่
        onTap: (LatLng tappedPoint) {
          print('User tapped at: $tappedPoint');
        },
      ),
    );
  }
}