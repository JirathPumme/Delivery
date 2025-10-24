import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Session/User_session.dart';
import 'package:delivery/model/order_data_list.dart';
import 'package:flutter/material.dart';
import 'package:delivery/components/custom_app_bar_rider.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery/pages/map_picker_screen.dart';
import 'package:delivery/pages/rider_map.dart';
import 'dart:developer' as developer;

class HomeRider extends StatefulWidget {
  const HomeRider({super.key});

  @override
  State<HomeRider> createState() => _HomeRiderState();
}

class _HomeRiderState extends State<HomeRider> {
  final TextEditingController _searchController = TextEditingController();

  /// ✅ Replace mock data with Firestore list
  List<Orderdatalist> ordersList = [];

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  getuserdata() async {
    UserSession user_data = UserSession.fromJson(
      await SessionManager().get("User"),
    );
    developer.log("Now User Session: " + user_data.user_table.toString());
  }

  Future<bool> Ondelivery_found() async {
    UserSession user_data = UserSession.fromJson(
      await SessionManager().get("User"),
    );
    String collectionName = "Ondelivery";
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(
      collectionName,
    );

    QuerySnapshot querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data["deliver_man_id"] == user_data.user_table) {
        return true;
      }
    }

    return false;
  }

  Future<void> Ondelivery(String orderid) async {
    UserSession user_data = UserSession.fromJson(
      await SessionManager().get("User"),
    );

    try {
      await FirebaseFirestore.instance.collection("Ondelivery").add({
        "order_id": orderid,
        "deliver_man_id": user_data.user_table.toString(),
        "status": 0,
      });

      final update_doc = FirebaseFirestore.instance
          .collection("Orders")
          .doc(orderid);

      final Map<String, dynamic> dataToupdate = {"status": 1};
      await update_doc.update(dataToupdate);
    } catch (err) {
      developer.log(err.toString());
    }
  }

  /// ✅ Get Orders from Firestore
  Future<void> getOrders() async {
    try {
      const String collectionName = "Orders";
      final collectionRef = FirebaseFirestore.instance.collection(
        collectionName,
      );

      final querySnapshot = await collectionRef.get();

      List<Orderdatalist> loadedOrders = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // ✅ Create Order model from Firestore data
        if (data["status"] != 0 || data["status"] == Null) {
          continue;
        }
        Orderdatalist order = Orderdatalist(
          id: doc.id,
          product: data["detail"]?.toString() ?? "ไม่มีข้อมูล",
          pickup: "${data["pickUp_lat"] ?? "0"} / ${data["pickUp_lng"] ?? "0"}",
          dropoff:
              "${data["dropOff_lat"] ?? "0"} / ${data["dropOff_lng"] ?? "0"}",
        );

        loadedOrders.add(order);

        developer.log("Loaded Order ID: ${order.id}");
      }

      // ✅ Update UI
      setState(() {
        ordersList = loadedOrders;
      });

      developer.log("Orders loaded: ${ordersList.length}");
    } catch (err) {
      developer.log("Error loading orders: $err");
    }
  }

  /// ✅ Dialog when Rider accepts order
  void _showConfirmationDialog(int itemNumber, Orderdatalist orderData) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          backgroundColor: Colors.grey[200],
          title: const Text(
            'รับสินค้า',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$itemNumber',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'สินค้า : ${orderData.product}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'สถานที่รับ : ${orderData.pickup}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'สถานที่ส่ง : ${orderData.dropoff}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                      onPressed: () => Navigator.of(dialogContext).pop(),
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
                      onPressed: () async {
                        developer.log('Accepted Order ID: ${orderData.id}');
                        if (await Ondelivery_found() == false) {
                          await Ondelivery(orderData.id);
                          setState(() {
                            ordersList.clear();
                          });
                          await getOrders();

                          // getOrders();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => RiderMapPage(orderId: orderData.id),
                              builder: (context) =>
                                  RiderMapPage(orderId: orderData.id),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                          final snackBar = SnackBar(
                            content: const Text(
                              'คุณมีออเดอร์ที่ต้องจัดส่งแล้ว!',
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
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

  Future<void> _pickLocationFromMapForSearch() async {
    if (!mounted) return;

    final LatLng? selectedPosition = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerScreen()),
    );

    if (selectedPosition != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'เลือกตำแหน่ง: ${selectedPosition.latitude.toStringAsFixed(4)}, ${selectedPosition.longitude.toStringAsFixed(4)}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent[700],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหา',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_on, color: Colors.grey[600]),
                  onPressed: _pickLocationFromMapForSearch,
                ),
              ),
            ),
          ),

          /// ✅ Show list of orders
          Expanded(
            child: ordersList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: ordersList.length,
                    itemBuilder: (context, index) {
                      final order = ordersList[index];
                      return _buildOrderItem(index + 1, order);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(int itemNumber, Orderdatalist orderData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 2,
      child: InkWell(
        onTap: () => _showConfirmationDialog(itemNumber, orderData),
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Text(
                '$itemNumber',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สินค้า : ${orderData.product}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'สถานที่รับ : ${orderData.pickup}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'สถานที่ส่ง : ${orderData.dropoff}',
                      style: const TextStyle(color: Colors.grey),
                    ),
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
