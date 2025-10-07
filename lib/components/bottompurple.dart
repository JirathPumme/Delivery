import 'package:flutter/material.dart';

class DecorativeBottomBar extends StatelessWidget {
  const DecorativeBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      color: Colors.deepPurple[800],
    );
  }
}