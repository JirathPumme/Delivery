import 'package:delivery/pages/้home_rider.dart';
import 'package:delivery/pages/list_rider_page.dart';
import 'package:delivery/components/custombottombavbar.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // อัปเดต State เพื่อให้ไอคอนที่ถูกเลือกเปลี่ยนสี
    setState(() {
      _selectedIndex = index;
    });

    // ---- นี่คือส่วนของ Logic การเปลี่ยนหน้า ----
    if (index == 0) {
      // ถ้ากดปุ่ม Home (index 0) ให้ไปหน้า HomeRiderPage
      // ใช้ pushReplacement เพื่อไม่ให้ย้อนกลับมาหน้าเดิมซ้ำๆ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeRider()),
      );
    } else if (index == 1) {
      // ถ้ากดปุ่ม List (index 1) ให้ไปหน้า ListPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ListRiderPage()),
      );
    } else if (index == 2) {
      // ถ้ากดปุ่ม Settings (index 2) ให้ไปหน้า SettingPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Setting')),
      body: const Center(
        child: Text(''),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
