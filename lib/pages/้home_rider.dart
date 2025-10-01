import 'package:flutter/material.dart';
import 'package:delivery/components/purplebottom.dart'; // 1. import component ของเรา

class HomeRider extends StatefulWidget {
  const HomeRider({super.key});

  @override
  State<HomeRider> createState() => _HomeRiderState();
}

class _HomeRiderState extends State<HomeRider> {
  
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
      appBar: AppBar(title:  Text('HomePageRider')),
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