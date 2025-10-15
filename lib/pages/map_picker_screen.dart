// ไฟล์ map_picker_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(13.7563, 100.5018),
    zoom: 12,
  );

  GoogleMapController? _mapController;
  Marker? _selectedMarker;

  @override
  void initState() {
    super.initState();
    _goToCurrentUserLocation();
  }

  Future<void> _goToCurrentUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (e)
     {
      /////////
     }
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      _selectedMarker = Marker(
        markerId: const MarkerId('selected_location'),
        position: tappedPoint,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จิ้มเลือกตำแหน่ง'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_selectedMarker != null) {
                Navigator.of(context).pop(_selectedMarker!.position);
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _mapController = controller,
        onTap: _handleTap,
        markers: _selectedMarker != null ? {_selectedMarker!} : {},
      ),
    );
  }
}