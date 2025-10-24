import 'package:delivery/pages/Login.dart';
import 'package:delivery/pages/profile_rider_fix.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class SettingPageRider extends StatefulWidget {
  const SettingPageRider({super.key});

  @override
  State<SettingPageRider> createState() => _SettingPageRiderState();
}

class _SettingPageRiderState extends State<SettingPageRider> {
  // bool isFirst = true; // <--- ตัวแปรนี้ไม่ได้ถูกใช้ ลบออกได้ค่ะ
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.indigo[600],
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween, // <--- เอา SpaceBetween ออก
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- ส่วนบน (ปุ่มแก้ไขโปรไฟล์) ---
            Column(
              children: [
                const SizedBox(height: 40), // ระยะห่างจากด้านบน
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileRiderFix(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[500],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'แก้ไขโปรไฟล์',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(), // <--- ใช้ Spacer() แทน SpaceBetween เพื่อดันปุ่มล่างลงไป

            // --- ส่วนล่าง (ปุ่มออกจากระบบ) ---
            ElevatedButton(
              onPressed: () {
                // TODO: Firebase signOut()
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[500],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'ออกจากระบบ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // <--- เพิ่ม SizedBox ตรงนี้! เพื่อสร้างระยะห่างจากขอบล่าง
            // หรือจะใช้ Padding ครอบ ElevatedButton ก็ได้ค่ะ:
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 20.0), // <-- กำหนดระยะห่างจากขอบล่าง
            //   child: ElevatedButton(
            //     // ... (ปุ่มเหมือนเดิม) ...
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
 }
}

// ฟังก์ชัน logout() ไม่ได้ถูกเรียกใช้ในโค้ดนี้ ลบออกได้ค่ะ
// void logout() {
//   developer.log("Logout button work!!");
// }