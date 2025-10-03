import 'package:flutter/material.dart';
import 'package:delivery/components/custom_app_bar.dart';

class HomeUser extends StatelessWidget {
  const HomeUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent[700],
      appBar: const CustomAppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 45),
            ElevatedButton(
              onPressed: () {},

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

            ElevatedButton(
              onPressed: () {},

              style: ElevatedButton.styleFrom(
                // สีพื้นหลังปุ่ม
                backgroundColor: Colors.grey[200],
                // สีตัวอักษรและเงาตอนกด
                foregroundColor: Colors.black,
                // ขนาด (กว้าง, สูง)
                minimumSize: const Size(280, 90),
                // ทำให้ขอบโค้งมน
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5, // เพิ่มเงาเล็กน้อย
              ),

              child: const Text(
                'รับสินค้า',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}