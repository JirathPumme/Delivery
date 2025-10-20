import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  // สร้าง Controller สำหรับควบคุมแผนที่
  GoogleMapController? _mapController;
  
  // กำหนดพิกัดเริ่มต้น (จะเอาที่ไหนก็ได้)
  static const LatLng _initialPosition = LatLng(13.7563, 100.5018); // กรุงเทพ

  // สร้าง 'Set' สำหรับเก็บ Markers ทั้งหมด
  final Set<Marker> _markers = {
    // ปักหมุดเริ่มต้นไว้ที่นี่
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
        // --- ส่วนที่สำคัญที่สุด ---
        initialCameraPosition: const CameraPosition(
          target: _initialPosition, // กล้องจะเริ่มที่พิกัดนี้
          zoom: 14.0,              // ระดับการซูม
        ),
        
        // บอกให้แผนที่ใช้ Markers ที่เราสร้างไว้
        markers: _markers, 
        
        // ฟังก์ชันที่จะทำงานเมื่อแผนที่ถูกสร้างเสร็จ
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        
        // ฟังก์ชันที่จะทำงานเมื่อผู้ใช้ 'จิ้ม' บนแผนที่
        onTap: (LatLng tappedPoint) {
          print('User tapped at: $tappedPoint');
          // นายสามารถเพิ่ม Marker ใหม่ตรงจุดที่จิ้มได้ตรงนี้!
        },
      ),
    );
  }
}