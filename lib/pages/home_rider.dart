import 'package:flutter/material.dart';
import 'package:delivery/components/custom_app_bar_rider.dart';
class HomeRider extends StatefulWidget {
  const HomeRider({super.key});

  @override
  State<HomeRider> createState() => _HomeRiderState();
}

class _HomeRiderState extends State<HomeRider> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarRider(
      ),
      body: const Center(
        child: Text(''),
      ),
    );
  }
}