import 'dart:async';

import 'package:flutter/material.dart';
import 'package:delivery/components/custombottombavbar.dart';
import 'package:delivery/pages/home_user.dart';
import 'package:delivery/pages/list_user_page.dart';
import 'package:delivery/pages/setting_page.dart';
import 'package:delivery/components/custom_app_bar.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;
  
  bool _hasIncomingPackage = true;

  @override
  void initState() {
    super.initState();
    // สร้าง 'สถานการณ์จำลอง' ---
    // จำลองว่าหลังจากเปิดแอป 3 วินาที มีของมาส่ง!
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _hasIncomingPackage = true; // สั่งให้แสดงไอคอน true = show false = Not
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('สินค้ากำลังนำส่ง!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  late final List<Widget> _pages = <Widget>[
    HomeUser(hasIncomingPackage: _hasIncomingPackage),
    const ListUserPage(),
    const SettingPage(),
  ];
  

 /* static const List<Widget> _pages = <Widget>[
    HomeUser(),   // Index 0
    ListUserPage(),   // Index 1
    SettingPage(),    // Index 2
  ];*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}