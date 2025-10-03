import 'package:flutter/material.dart';

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title:  Text('List รายการ')),
      body: const Center(
        child: Text(''),
      ),

    );
  }
}