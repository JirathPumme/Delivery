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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Setting')),
      body: const Center(
        child: Text(''),
      ),

    );
  }
}
