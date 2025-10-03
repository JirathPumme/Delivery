import 'package:flutter/material.dart';

class ProfileRider extends StatefulWidget {
  const ProfileRider({super.key});

  @override
  State<ProfileRider> createState() => _ProfileRiderState();
}

class _ProfileRiderState extends State<ProfileRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text('Profile_Rider')),
      body: const Center(
        child: Text(''),
      ),

    );
  }
}