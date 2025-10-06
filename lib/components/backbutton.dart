import 'package:flutter/material.dart';

class Backbutton extends StatelessWidget {
  const Backbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.amber,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

//็How to Use
/*@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: const Center(
        child: Text(''),
      ),
      bottomNavigationBar: const DecorativeBottomBar(),
    );
  }*/