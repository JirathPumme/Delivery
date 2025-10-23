import 'package:delivery/Session/User_session.dart';
import 'package:delivery/pages/ready_delivery.dart';
import 'package:delivery/pages/wait_rider_recieve.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:developer' as developer;

class HomeUser extends StatelessWidget {
  final bool hasIncomingPackage;


  const HomeUser({
    super.key,
    required this.hasIncomingPackage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.yellowAccent[700],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 45),

            ElevatedButton(
              onPressed: ()
              {
                getuserdata();
                Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => const ReadyDelivery()),
                    );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                minimumSize: const Size(280, 90),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),

              child: const Text(
                'ส่งด่วน',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Text(''),

            Stack(
            clipBehavior: Clip.none,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaitRiderRecieve(
                        deliveryId: "ID_ของที่กำลังมาส่ง", // <-- นายต้องหา ID ของของที่มาส่งให้เจอ
                        role: TrackingUserRole.receiver, // <-- ระบุว่าเป็น Receiver
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(280, 90),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text('รับสินค้า', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              
              // ไอคอนแจ้งเตือน (จะแสดงก็ต่อเมื่อ hasIncomingPackage เป็น true) ---
              if (hasIncomingPackage)
                Positioned(
                  top: 10,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.priority_high, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }

  getuserdata() async {
    UserSession user_data = UserSession.fromJson(await SessionManager().get("User"));
    developer.log("Now User Session: "+user_data.user_table.toString());
  }

}