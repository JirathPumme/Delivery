import 'package:delivery/components/custom_app_bar.dart';
import 'package:delivery/pages/complete_sender_page.dart';
import 'package:delivery/pages/ready_delivery.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:cloud_firestore/clousd_firestore.dart';
import 'dart:async';
enum TrackingUserRole { sender, receiver }

class WaitRiderRecieve extends StatefulWidget {
  final String deliveryId;
  final TrackingUserRole role;

  const WaitRiderRecieve({
    super.key,
    required this.deliveryId,
    required this.role,
  });

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
  String _currentStatusText = '';


  final List<Map<String, String>> _mockItems = [
    /*{
      "product": "มังงะโคนัน เล่ม 1",
      "pickup": "บ้านเลขที่ XX ซอย yy",
      "dropoff": "สถานที่ส่ง ZZ",
    },
     
     {
       "product": "ฟิกเกอร์อาสึกะ",
       "pickup": "บ้านเลขที่ XX ซอย yy",
       "dropoff": "สถานที่ส่ง ZZ",
     },*/
  ];


  /*@override
  void initState() {
    super.initState();

    _runStatusSimulation();
  }*/

  /*void _runStatusSimulation() {
        //(จำลอง) ไรเดอร์กดรับงาน
        Timer(const Duration(seconds: 2), () {
          setState(() {
            _currentStatusText = 'ไรเดอร์รับงานแล้ว';
            _showStatusOverlay = true;
          });

        //ซ่อนข้อความ
        Timer(const Duration(seconds: 5), () {
          setState(() {
            _showStatusOverlay = false;
          });

        //ไรเดอร์กําลังเดินทางมารับสินค้า
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _currentStatusText = 'ไรเดอร์กำลังเดินทางมารับสินค้า';
            _showStatusOverlay = true; 
          });

        //ซ่อนข้อความ
        Timer(const Duration(seconds: 5), () {
          setState(() {
            _showStatusOverlay = false;
          });

        //ไรเดอร์รับสินค้าแล้ว (กําลังเดินทางไปส่งสินค้า)
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            _currentStatusText = 'ไรเดอร์กําลังเดินทางไปส่งสินค้า';
            _showStatusOverlay = true; 
        });
            });
          });
        }); 
      });
    });
  }*/

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
            //เมื่อแผนที่พร้อมใช้งาน...
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller; //เก็บ 'รีโมท' ไว้

              // สั่งให้กล้องเคลื่อนที่ไปที่เป้าหมายทันที!
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

            
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        controller: scrollController, // ส่ง Controller ให้ ListView!
                        padding: EdgeInsets.fromLTRB(0,5,0,0),
                        itemCount: _mockItems.length + 1, 
                        itemBuilder: (BuildContext context, int index) {
                          
                          if (index == _mockItems.length) {
                         

                            // ถ้าเป็น 'Sender' ให้แสดงปุ่ม 'ยกเลิก'
                            if (widget.role == TrackingUserRole.sender) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                  onPressed: () { /*กลับไปหน้า ReadyDelivery */ },
                                  child: const Text('ยกเลิก'),
                                ),
                              );
                            }
                            // ถ้าเป็น 'Receiver' ให้แสดงปุ่ม 'ยืนยันการรับสินค้า'
                            else if (widget.role == TrackingUserRole.receiver) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 78, 230, 84)),
                                  onPressed: () {
                                    // TODO: อัปเดตสถานะใน Firebase เป็น [4]
                                    
                                    if (!mounted) return;

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CompleteSenderPage(
                                      showConfirmationPopup: true
                                      )),
                                    );
                                  },
                                  child: const Text('ยืนยันการรับสินค้า',
                                  style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.bold),),
                                ),
                              );
                            }
                           
                            return const SizedBox.shrink();

                          }

                                                
                          // รายการสินค้า 
                          final item = _mockItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                            elevation: 4, 
                            child: ListTile(
                              title: Text(item['product']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('สถานที่รับ : ${item['pickup']}\nสถานที่ส่ง : ${item['dropoff']}'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),


          // หน้าต่างแจ้งเตือน
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
                  color: Colors.indigo[600],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5)],
                ),
                child: Text(
                  _currentStatusText,
                  style: TextStyle(color: Colors.yellow, fontSize: 16, fontWeight: FontWeight.bold),
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
