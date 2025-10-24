import 'package:delivery/components/Navigator_back.dart';
import 'package:delivery/components/custom_app_bar_rider.dart';
import 'package:delivery/pages/home_rider.dart';
import 'package:flutter/material.dart';
import 'package:delivery/components/custombottombavbar.dart';
import 'package:delivery/pages/home_rider.dart';
import 'package:delivery/pages/list_rider_page.dart';
import 'package:delivery/pages/setting_page.dart';
import 'package:delivery/pages/Setting_page_rider.dart';
import 'dart:developer' as developer;

class RiderMainScreen extends StatefulWidget {
  const RiderMainScreen({super.key});

  @override
  State<RiderMainScreen> createState() => _RiderMainScreenState();
}

class _RiderMainScreenState extends State<RiderMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeRider(),   // Index 0
    ListRiderPage(),   // Index 1
    SettingPageRider(),     // Index 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    developer.log("hii");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarRider(),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, 
      ),
      // Text("Hello"),
    );
  }
}