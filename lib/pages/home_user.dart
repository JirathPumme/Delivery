import 'package:flutter/material.dart';
import 'package:delivery/pages/Login.dart';
import 'package:delivery/pages/Splash_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:delivery/config/Apptheme.dart';
import 'package:delivery/components/custombottombavbar.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}


class _HomeUserState extends State<HomeUser> {
   int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // คุณสามารถใส่ logic เพิ่มเติมที่นี่ได้ เช่นการเปลี่ยนหน้า
      // if (index == 0) { // Navigate to Home }
      // if (index == 1) { // Navigate to Orders }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePageUser')),
      body: const Center(
        child: Text(''),
      ),
        bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // คุณสามารถใส่ Logic การเปลี่ยนหน้าของคุณได้ที่นี่
          });
        },
      ),
    );
  }
}