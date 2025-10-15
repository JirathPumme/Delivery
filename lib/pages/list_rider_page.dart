import 'package:flutter/material.dart';

class ListRiderPage extends StatefulWidget {
  const ListRiderPage ({super.key});

  @override
  State<ListRiderPage > createState() => _ListRiderPageState();
}

class _ListRiderPageState extends State<ListRiderPage > {
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