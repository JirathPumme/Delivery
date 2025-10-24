//เตรียมOrder ของฝั่ง User Sender
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Session/User_session.dart';
import 'package:delivery/pages/confirm_order.dart';
import 'package:delivery/pages/profile_user.dart';
import 'package:delivery/pages/wait_rider_recieve.dart';
import 'package:flutter/material.dart';
import 'package:delivery/components/custom_app_bar.dart';
//import 'package:delivery/components/backbutton.dart';
import 'package:delivery/components/address_input_card.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery/pages/map_picker_screen.dart';
import 'package:delivery/components/quantity_selector.dart';
import 'package:delivery/components/item_detail_card.dart';
import 'dart:developer' as developer;

class ReadyDelivery extends StatefulWidget {
  const ReadyDelivery({super.key});

  @override
  State<ReadyDelivery> createState() => _ReadyDeliveryState();
}

class _ReadyDeliveryState extends State<ReadyDelivery> {
  int _quantity = 0;
  List<ItemDetailCard> _itemDetails = [];


  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  final TextEditingController _receiverPhoneController = TextEditingController();
  var itemdropOffdetail = TextEditingController();
  String pickUp_lat = "";
  String pickUp_lng = "";
  String dropOff_lat = "";
  String dropOff_lng = "";

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    _receiverPhoneController.dispose(); 
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }



void _showConfirmationDialog() {

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('ยืนยัน', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ส่งสินค้า', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
          
            Text('สินค้าจำนวน: $_quantity รายการ'),
            Text('ส่งให้เบอร์: ${_receiverPhoneController.text}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(dialogContext).pop(), // ปิด Pop-up
          ),
          TextButton(
            child: const Text('ตกลง', style: TextStyle(color: Colors.green)),
            onPressed: () async {
              if (await field_req()) {
              developer.log("Confirmed! Firing data to Firebase...");
              // UserSession user_data = UserSession.fromJson(await SessionManager().get("User"));
              // add_to_order(user_data.user_table.toString(), _receiverPhoneController.text, itemdropOffdetail.text);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WaitRiderRecieve(
                    deliveryId: '',
                    role: TrackingUserRole.sender, // <-- ระบุว่าเป็น Sender
                  ),
                ),
              );
              // ใส่ Firebase 
              //Navigator.of(dialogContext).pop(); // ปิด Pop-up
              //Navigator.of(context).pop();      // กลับไปหน้า Home

              } else {
                return;
              }


            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
      );
    },
  );
}

  Future<void> _pickLocationFromMap(int drop_or_pick) async { // Removed bool isDropoff

  // 1. Simplified navigation (since both paths were identical)
  final LatLng? selectedPosition = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MapPickerScreen()),
  );

  if (selectedPosition != null) {
    final newAddress = 'Lat: ${selectedPosition.latitude.toStringAsFixed(4)}, Lng: ${selectedPosition.longitude.toStringAsFixed(4)}';
    developer.log(newAddress);
    
    setState(() {
      // 2. Logic to correctly set the controller based on the number
      if (drop_or_pick == 2) {
        // Set Dropoff address
        _dropoffController.text = newAddress;
        dropOff_lat = selectedPosition.latitude.toStringAsFixed(4);
        dropOff_lng = selectedPosition.longitude.toStringAsFixed(4);
      } else if (drop_or_pick == 1) {
        // Set Pickup address
        _pickupController.text = newAddress;
        pickUp_lat = selectedPosition.latitude.toStringAsFixed(4);
        pickUp_lng = selectedPosition.longitude.toStringAsFixed(4);
        // developer.log("pickup here: "+_pickupController.text);
      }
      // Note: Added explicit 'else if (drop_or_pick == 1)' for clarity
    });
  }
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600],
        elevation: 0,
        leading: const BackButton(),
        actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white, size: 40),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileUser()),
            );
          },
        ),
        const SizedBox(width: 10),
      ],
      ),
      backgroundColor: Colors.yellowAccent[700],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            
            AddressInputCard(
              pickupController: _pickupController,
              dropoffController: _dropoffController,
              onPickupMapTap: () => _pickLocationFromMap(1),
              onDropoffMapTap: () => _pickLocationFromMap(2),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'หมายเลขโทรศัพท์ผู้รับ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _receiverPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'กรอกเบอร์โทร 10 หลัก',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: () {
                          //firebase put
                          final phoneNumber = _receiverPhoneController.text;
                          developer.log('กำลังค้นหาผู้รับด้วยเบอร์: $phoneNumber');
                          getuserdata();
                          // หลังจากค้นหาเจอ ก็เอาที่อยู่ไปใส่ใน _dropoffController.text
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreenAccent[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        child: const Text('ยืนยัน', style: TextStyle(fontSize: 17,color: Colors.black,fontWeight:FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // QuantitySelector(
            //   quantity: _quantity,
            //   onIncrement: _incrementQuantity,
            //   onDecrement: _decrementQuantity,
            // ),
            // const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'กรอกรายละเอียดสินค้า',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            
            // ListView.builder(
            //   itemCount: _quantity,
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     return ItemDetailCard(
            //       itemNumber: index + 1,
            //     );
            //   },
            // ),
            // const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                            controller: itemdropOffdetail,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'กรอกข้อมูลสินค้า',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                          ),
            ),
                      
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed:  () {
                  _showConfirmationDialog();
                  // get_data_to_delivery();
                  
                },
                /*()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfirmOrder()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('สร้างรายการสำเร็จ!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },*/

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent[400],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  getuserdata() async {
    UserSession user_data = UserSession.fromJson(await SessionManager().get("User"));
    developer.log("Now User Session: "+user_data.user_table.toString());
  }

  get_data_to_delivery() async {
    UserSession user_data = UserSession.fromJson(await SessionManager().get("User"));
    developer.log("Now User Session: "+user_data.user_table.toString());
    developer.log("PickUp Item: "+_pickupController.text);
    developer.log(pickUp_lat);
    developer.log(pickUp_lng);
    developer.log("DropOff Item: "+_dropoffController.text);
    developer.log(dropOff_lat);
    developer.log(dropOff_lng);
    developer.log("sender phone Number: "+_receiverPhoneController.text);
    developer.log("Text drop off detail: "+ itemdropOffdetail.text);
  }

  Future<void> add_to_order(String user_id, String receiver_number, String detail) async {
    try {
      await FirebaseFirestore.instance.collection("Orders").add({
        "sender_id": user_id,
        "receiver_phone": receiver_number,
        "detail": detail,
        "pickUp_lat": pickUp_lat,
        "pickUp_lng": pickUp_lng ,
        "dropOff_lat": dropOff_lat,
        "dropOff_lng": dropOff_lng,
        "status": 0
      });
    }catch (err) {
      developer.log(err.toString());
    }
  }

  Future<bool> field_req() async {
    if (_receiverPhoneController.text != "" && itemdropOffdetail.text != "" && pickUp_lat != "" && dropOff_lat != "") {
      UserSession user_data = UserSession.fromJson(await SessionManager().get("User"));
      add_to_order(user_data.user_table.toString(), _receiverPhoneController.text, itemdropOffdetail.text);
      return true;
    }else {
      developer.log("field can not be null");
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text('ข้อมูลไม่ครบถ้วน!'),
      backgroundColor: Color.fromARGB(255, 255, 0, 0),
      ),
      );
      return false;
    }
  }
  
}
