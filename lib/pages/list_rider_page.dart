import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/Session/User_session.dart';
import 'package:delivery/model/ondelivery_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:developer' as developer;

class ListRiderPage extends StatefulWidget {
  const ListRiderPage({super.key});

  @override
  State<ListRiderPage> createState() => _ListRiderPageState();
}

class _ListRiderPageState extends State<ListRiderPage> {
  List<OndeliveryList> ondelivery_list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getuserdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการพัสดุของไรเดอร์')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ondelivery_list.isEmpty
              ? const Center(
                  child: Text(
                    'ไม่มีรายการพัสดุในขณะนี้',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: ondelivery_list.length,
                  itemBuilder: (context, index) {
                    final order = ondelivery_list[index];
                    String statusText = '';

                    if (order.status == '1') {
                      statusText = 'กำลังเข้ารับพัสดุ';
                    } else {
                      statusText = 'สถานะอื่น ๆ (${order.status})';
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.local_shipping,
                            color: Colors.deepPurple),
                        title: Text(
                          order.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          "เบอร์ผู้รับ: ${order.phoneReciver}\n"
                          "สถานะ: $statusText\n"
                          "จุดรับ: ${order.pickup}\n"
                          "จุดส่ง: ${order.dropoff}",
                          style: const TextStyle(height: 1.4),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> getOndelivery(String delivery_man_id) async {
    const collectionName = "Ondelivery";
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection(collectionName);

      QuerySnapshot querySnapshot = await collectionRef.get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data["deliver_man_id"] == delivery_man_id) {
          CollectionReference ordersRef =
              FirebaseFirestore.instance.collection("Orders");

          QuerySnapshot ordersSnapshot = await ordersRef.get();
          for (var doc2 in ordersSnapshot.docs) {
            Map<String, dynamic> order =
                doc2.data() as Map<String, dynamic>; // fixed line

            if (doc2.id == data["order_id"]) {
              String pickup =
                  "${order["pickUp_lat"]}, ${order["pickUp_lng"]}";
              String dropoff =
                  "${order["dropOff_lat"]}, ${order["dropOff_lng"]}";

              ondelivery_list.add(
                OndeliveryList(
                  title: order["detail"],
                  phoneReciver: order["receiver_phone"].toString(),
                  pickup: pickup,
                  dropoff: dropoff,
                  status: order["status"].toString(),
                ),
              );
            }
          }
        }
      }

      setState(() => isLoading = false);
    } catch (err) {
      developer.log("Error in getOndelivery: $err");
      setState(() => isLoading = false);
    }
  }

  Future<void> getuserdata() async {
    UserSession user_data =
        UserSession.fromJson(await SessionManager().get("User"));
    developer.log("Now User Session: ${user_data.user_table}");
    await getOndelivery(user_data.user_table.toString());
  }
}
