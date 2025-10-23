import 'package:flutter/material.dart';
import 'package:delivery/components/custom_app_bar_rider.dart';
import 'package:delivery/components/address_input_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery/pages/map_picker_screen.dart';
import 'package:delivery/pages/wait_rider_recieve.dart';
import 'package:delivery/pages/rider_map.dart';
import 'dart:developer' as developer;
import 'dart:developer' as developer;

class HomeRider extends StatefulWidget {
  const HomeRider({super.key});

  @override
  State<HomeRider> createState() => _HomeRiderState();
}

class _HomeRiderState extends State<HomeRider> {
  final TextEditingController _searchController = TextEditingController();
  
  // --- ข้อมูลจำลอง (Mock Data) ---
  // TODO: ดึงข้อมูล Order จริงจาก Firestore (ที่ status เป็น 'รอไรเดอร์มารับ')
  final List<Map<String, String>> _mockOrders = List.generate(
    3, //จํานวนรายการ จําลอง
    (index) => {
      'id': 'order_${index + 1}', // ใส่ ID เผื่อไว้กดรับงาน
      'product': 'สินค้า ${index + 1}', // ชื่อสินค้าจำลอง
      'pickup': 'xx/xx ${index + 1}', // สถานที่รับจำลอง
      'dropoff': 'zz/zz ${index + 1}', // สถานที่ส่งจำลอง
    },
  );
  // --- สิ้นสุดข้อมูลจำลอง ---

  // --- ฟังก์ชัน _pickLocationFromMapForSearch (จากครั้งก่อน) ---
  Future<void> _pickLocationFromMapForSearch() async { 
  if (!mounted) return;

  final LatLng? selectedPosition = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MapPickerScreen()),
  );

  if (selectedPosition != null) {
    // TODO: เอา selectedPosition ไปใช้งานต่อ
    developer.log('Selected location for search: ${selectedPosition.latitude}, ${selectedPosition.longitude}');
    // ตัวอย่าง: อาจจะเอาไปใส่ในช่องค้นหา
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('เลือกตำแหน่ง: ${selectedPosition.latitude.toStringAsFixed(4)}, ${selectedPosition.longitude.toStringAsFixed(4)}')),
     );
  }
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  
  void _showConfirmationDialog(int itemNumber, Map<String, String> orderData) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          backgroundColor: Colors.grey[200],
          title: const Text(
            'รับสินค้า', // หัวข้อ Dialog
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(0), 
          content: Container( 
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                //Order detail 

                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(15.0),
                   ),
                   child: Row(
                     children: [
                       Text(
                         '$itemNumber',
                         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               'สินค้า : ${orderData['product'] ?? 'N/A'}',
                               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                               overflow: TextOverflow.ellipsis,
                             ),
                             const SizedBox(height: 4),
                             Text(
                               'สถานที่รับ : ${orderData['pickup'] ?? 'N/A'}',
                               style: const TextStyle(fontSize: 12, color: Colors.grey),
                               overflow: TextOverflow.ellipsis,
                             ),
                             const SizedBox(height: 2),
                             Text(
                               'สถานที่ส่ง : ${orderData['dropoff'] ?? 'N/A'}',
                               style: const TextStyle(fontSize: 12, color: Colors.grey),
                               overflow: TextOverflow.ellipsis,
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
                 // --- สิ้นสุดส่วนแสดงรายละเอียด ---
                 const SizedBox(height: 20),
                 const Text(
                   'ยืนยัน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                 ),
                 const SizedBox(height: 15),
              
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                   children: [
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.red,
                         foregroundColor: Colors.white,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                         padding: const EdgeInsets.symmetric(horizontal: 30),
                       ),
                       onPressed: () {
                         Navigator.of(dialogContext).pop(); 
                       },
                       child: const Text('ยกเลิก'),
                     ),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.lightGreenAccent[400],
                         foregroundColor: Colors.black,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                         padding: const EdgeInsets.symmetric(horizontal: 30),
                       ),
                       onPressed: () {
                         //Navigator.of(dialogContext).pop(); // ปิด Dialog ก่อน
                         // TODO: อัปเดตสถานะ Order ใน Firebase เป็น [2] (ไรเดอร์รับงาน)
                         developer.log('Accepted Order ID: ${orderData['id']}');

                         
                         Navigator.push(
                           context, 
                           MaterialPageRoute(
                             builder: (context) => RiderMapPage(
                               orderId: orderData['id']!, // <<-- Rider เห็นสถานะเหมือน Sender
                             ),
                           ),
                         );
                       },
                       child: const Text('ตกลง'),
                     ),
                   ],
                 ),
              ],
            ),
          ),
  
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: สร้าง List ที่จะแสดงผลจริง โดยอาจจะกรอง _mockOrders จาก _searchController.text
    final List<Map<String, String>> displayOrders = _mockOrders;

    return Scaffold(
      appBar: const CustomAppBarRider(),
      backgroundColor: Colors.yellowAccent[700],
      body: Column( 
        children: [
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหา',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]), 
                filled: true, 
                fillColor: Colors.white, 
                border: OutlineInputBorder( 
                  borderRadius: BorderRadius.circular(30.0), 
                  borderSide: BorderSide.none, 
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0), 
                
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.location_on, color: Colors.grey[600]),

                    onPressed: _pickLocationFromMapForSearch, 
                   
                  ),
                ),
              ),

              onChanged: (value) {
               
                setState(() {
                  
                  developer.log('Filtering for: $value');
                });
              },
            ),
          ),
          //  สิ้นสุดช่องค้นหา 

          //  ส่วนแสดงรายการ 
          Expanded(
            child: Padding(
              
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack( 
                 children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        width: 50,  
                        height: 5,   
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                   
                   Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: ListView.builder(
                      itemCount: displayOrders.length,
                      itemBuilder: (context, index) {
                        final order = displayOrders[index];
                        //  แก้ไขตรงนี้ ให้เรียก _buildOrderItem 
                        return _buildOrderItem(index + 1, order);
                      },
                    ),
                  ),
                 ],
               ),
            ),
          ),
          // สิ้นสุดส่วนแสดงรายการ 
        ],
      ),
    );
  }
  //  Widget สำหรับสร้างรายการ Order แต่ละอัน
  Widget _buildOrderItem(int itemNumber, Map<String, String> orderData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 2,
      child: InkWell(
        // แก้ไข onTap ให้เรียก Dialog 
        onTap: () {
        _showConfirmationDialog(itemNumber, orderData); //  เรียก Dialog 
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Text( /* เลขลำดับ  */ '$itemNumber', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Expanded(
                child: Column( /*  ข้อความรายละเอียด  */
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('สินค้า : ${orderData['product'] ?? 'N/A'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('สถานที่รับ : ${orderData['pickup'] ?? 'N/A'}', style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('สถานที่ส่ง : ${orderData['dropoff'] ?? 'N/A'}', style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

