import 'package:delivery/components/custom_app_bar.dart';
import 'package:delivery/pages/ready_delivery.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:cloud_firestore/clousd_firestore.dart';
import 'dart:async';

class WaitRiderRecieve extends StatefulWidget {
  const WaitRiderRecieve({super.key});

  //static const LatLng _initialPosition = LatLng(13.7563, 100.5018);

  @override
  State<WaitRiderRecieve> createState() => _WaitRiderRecieveState();
}

class _WaitRiderRecieveState extends State<WaitRiderRecieve> {
  GoogleMapController? _mapController;

  // กำหนด 'พิกัดเป้าหมาย' (จุดรับสินค้า) ที่จะจำลอง
  static const LatLng _pickupLocation = LatLng(13.7462, 100.5347); // สยามพารากอน
  // กำหนดจุดเริ่มต้นของกล้องให้เห็นภาพรวมก่อน
  static const LatLng _initialCameraPosition = LatLng(13.7563, 100.5018); // กรุงเทพ

  //แสดงผลข้อความ
  bool _showStatusOverlay = false;

  @override
  void initState() {
    super.initState();
    // จำลอง
    // หน่วงเวลา 1 วินาทีก่อนแสดงผล เพื่อให้รู้สึกเหมือนมีการรอ Rider รับงาน
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _showStatusOverlay = true; // สั่งให้ 'แสดง'
      });

      // จากนั้นตั้งเวลาอีก 5 วินาทีเพื่อ 'ซ่อน'
      Timer(const Duration(seconds: 5), () {
        setState(() {
          _showStatusOverlay = false;
        });
      });
    });
  }

  final List<Map<String, String>> _mockItems = [
    {
      "product": "มังงะโคนัน เล่ม 1",
      "pickup": "บ้านเลขที่ XX ซอย yy",
      "dropoff": "สถานที่ส่ง ZZ",
    },
     
     {
       "product": "ฟิกเกอร์อาสึกะ",
       "pickup": "บ้านเลขที่ XX ซอย yy",
       "dropoff": "สถานที่ส่ง ZZ",
     },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(),
          ),

      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _initialCameraPosition, // เริ่มกล้องที่กรุงเทพ
              zoom: 15.0,
            ),
            // 4. เมื่อแผนที่พร้อมใช้งาน...
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller; // 4.1 เก็บ 'รีโมท' ไว้

              // 4.2 สั่งให้กล้องเคลื่อนที่ไปที่เป้าหมายทันที!
              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(target: _pickupLocation, zoom: 16.0),
                ),
              );
            },
            // เพิ่ม Marker ที่ตำแหน่งรับสินค้า
            markers: {
              const Marker(
                markerId: MarkerId('pickup_location'),
                position: _pickupLocation,
                infoWindow: InfoWindow(title: 'จุดรับสินค้า'),
              ),
            },
          ),
          
          // สไลด์
          DraggableScrollableSheet(
            initialChildSize: 0.3,  // ความสูงเริ่มต้น (30% ของจอ)
            minChildSize: 0.15,     // ความสูงต่ำสุดตอนพับเก็บ
            maxChildSize: 0.8,      // ความสูงสูงสุดตอนกางออก
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),


                child: ListView.builder(
                  controller: scrollController, // <-- ส่ง Controller ให้ ListView!
                  padding: EdgeInsets.fromLTRB(0,30,0,0), //ไม่ต้องเว้นบรรทัด
                  itemCount: _mockItems.length + 1, // +1 สำหรับปุ่มยกเลิก
                  itemBuilder: (BuildContext context, int index) {
                    

                    if (index == _mockItems.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const ReadyDelivery()),
                            );
                          },
                          child: Text('ยกเลิก',style: TextStyle(
                            fontWeight:FontWeight.bold
                          ),
                         ),
                        ),
                      );
                    }

                    // รายการสินค้า 
                    final item = _mockItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                      elevation: 4, 
                      child: ListTile( // เอา ListTile มาใส่เป็น child ของ Card
                        title: Text(item['product']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('สถานที่รับ : ${item['pickup']}\nสถานที่ส่ง : ${item['dropoff']}'),
                      ),
                    );
                  },
                ),
              );
            },
          ),


          // เพิ่มหน้าต่างแจ้งเตือน
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
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'ไรเดอร์รับงานแล้ว',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
