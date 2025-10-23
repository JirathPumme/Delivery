import 'package:delivery/pages/home_rider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:developer' as developer;

class RiderMapPage extends StatefulWidget {
  final String orderId;

  const RiderMapPage({
    super.key,
    required this.orderId,
  });

  @override
  State<RiderMapPage> createState() => _RiderMapPageState();
}

class _RiderMapPageState extends State<RiderMapPage> {
  final Completer<GoogleMapController> _controllerCompleter = Completer<GoogleMapController>();
  GoogleMapController? _mapController;
  static const LatLng _initialCameraPosition = LatLng(13.7563, 100.5018); 
  bool _showStatusOverlay = false;
  String _currentStatusText = '';

  // --- Mock Data ---
  late Map<String, dynamic> _currentOrderData;
  late List<Map<String, String>> orderItems; 
  // --- สิ้นสุด ---

  @override
  void initState() {
    super.initState();
    //  แก้ไข: กำหนดข้อมูลจำลองให้ถูกต้อง 
    _currentOrderData = {
      'id': widget.orderId,
      //  ใส่ items list กลับมา 
      'items': [
        {'name': 'มังงะ เล่ม 1', 'detail': 'ห่อกันกระแทก'},
        
      ],
      'pickup': 'xx/xx', // สถานที่รับจำลอง
      'dropoff': 'zz/zz', // สถานที่ส่งจำลอง
      'imageUrl': 'image' 
    };
   

    // กำหนดค่าให้ orderItems หลังจาก _currentOrderData ถูกสร้าง
    orderItems = _currentOrderData['items'] is List
        ? List<Map<String, String>>.from(
            (_currentOrderData['items'] as List).map((item) => Map<String, String>.from(item))
          )
        : [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStatusUpdate('กำลังเดินทางไปรับสินค้า');
    });
  }

  void _showStatusUpdate(String statusText) {
    if (mounted) {
      setState(() {
        _currentStatusText = statusText;
        _showStatusOverlay = true;
      });
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() { _showStatusOverlay = false; });
        }
      });
    }
  }

  // แก้ไข: ฟังก์ชันสร้าง Dialog ยืนยัน (เอา Argument ออก) 
  void _showPickupConfirmationDialog() { //  ไม่มี Argument แล้ว
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*Container( // ข้อความ "รับสินค้าสำเร็จ"
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                child: const Text('รับสินค้าสำเร็จ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),*/
              const SizedBox(height: 15),
              const Align(
                 alignment: Alignment.centerRight,
                 child: Icon(Icons.camera_alt, size: 30, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Image.network(
                 _currentOrderData['imageUrl'] as String? ?? '',
                 height: 200, fit: BoxFit.contain,
                 errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                 loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  ใช้ member variable this.orderItems
                    Text('สินค้า : ${this.orderItems.isNotEmpty ? this.orderItems[0]['name'] : 'N/A'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('สถานที่รับ : ${_currentOrderData['pickup'] ?? 'N/A'}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 3),
                    Text('สถานที่ส่ง : ${_currentOrderData['dropoff'] ?? 'N/A'}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton( 
                 style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreenAccent[400], foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                 onPressed: () {
                   Navigator.of(dialogContext).pop(); // ปิด Dialog
                   // TODO: ใส่ Logic สำหรับปุ่มต่อไป (เช่น เริ่มนำทางไปจุดส่ง)
                   developer.log('Next button pressed for Order ID: ${widget.orderId}');
                   _showStatusUpdate('กำลังเดินทางไปส่งสินค้า'); // แสดง Pop-up สถานะถัดไป
                 },
                 child: const Text('ยืนยัน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar( 
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true, 
      body: Stack(
        children: [
  
          GoogleMap(
             mapType: MapType.normal,
             initialCameraPosition: const CameraPosition(target: _initialCameraPosition, zoom: 14.0),
             onMapCreated: (GoogleMapController controller) {
               if (!_controllerCompleter.isCompleted) { _controllerCompleter.complete(controller); }
               _mapController = controller;
               developer.log('Map Created for Order: ${widget.orderId}');
               // TODO: เคลื่อนกล้องไปยังตำแหน่งจริง
             },
             markers: {}, // TODO: เพิ่ม Markers
             polylines: {}, // TODO: เพิ่ม Polylines
             myLocationEnabled: true,
             myLocationButtonEnabled: true,
          ),

          
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: AnimatedOpacity(
                opacity: _showStatusOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.indigo[600], borderRadius: BorderRadius.circular(30),
                    boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 3)) ],
                  ),
                  child: Text(_currentStatusText, style: const TextStyle(color: Colors.yellow, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
           ),

          
          DraggableScrollableSheet(
            initialChildSize: 0.4, minChildSize: 0.2, maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  boxShadow: [ BoxShadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.2)), ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)))), // Indicator
                        const SizedBox(height: 15),
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded( 
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('สถานที่รับ : ${_currentOrderData['pickup'] ?? 'N/A'}', style: const TextStyle(fontSize: 14, color: Colors.grey), overflow: TextOverflow.ellipsis,),
                                  const SizedBox(height: 3),
                                  Text('สถานที่ส่ง : ${_currentOrderData['dropoff'] ?? 'N/A'}', style: const TextStyle(fontSize: 14, color: Colors.grey), overflow: TextOverflow.ellipsis,),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10), 
                            TextButton( 
                              onPressed: () {                              
                                Navigator.of(context).popUntil((route) => route.settings.name == '/rider_main_screen');
                              
                              },
                              style: TextButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),),
                              child: const Text('ยกเลิก'),
                             ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text('สินค้า:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        // ใช้ member variable this.orderItems 
                        ListView.builder(
                          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                          itemCount: this.orderItems.length, 
                          itemBuilder: (context, index) {
                            final item = this.orderItems[index]; 
                            return Container(
                               margin: const EdgeInsets.only(bottom: 8.0), padding: const EdgeInsets.all(12.0),
                               decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                               child: Text(item['name'] ?? 'N/A', style: const TextStyle(fontSize: 14)),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton( // ปุ่มยืนยัน
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreenAccent[400], foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          onPressed: () {
                            // TODO: อัปเดตสถานะใน Firebase เป็น [3]
                            developer.log('Confirm Pickup pressed for Order ID: ${widget.orderId}');
                            //  เรียก Dialog โดยไม่ต้องส่ง argument 
                            _showPickupConfirmationDialog();
                          },
                          child: const Text('ยืนยันการรับสินค้า', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}