import 'package:flutter/material.dart';
import 'package:delivery/components/custombottombavbar.dart';
import 'package:delivery/pages/home_user.dart';
import 'package:delivery/pages/list_user_page.dart';
import 'package:delivery/pages/setting_page.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;

  // ลิสต์ของหน้าจอที่จะสลับ
  static const List<Widget> _pages = <Widget>[
    HomeUser(),   // Index 0
    ListUserPage(),   // Index 1
    SettingPage(),    // Index 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}