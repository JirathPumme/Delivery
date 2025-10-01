import 'package:flutter/material.dart';

class DecorativeBottomBar extends StatelessWidget {
  const DecorativeBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    // เราใช้ Container ธรรมดาเพื่อสร้างแถบสี
    return Container(
      // ใช้ความสูงมาตรฐานของ BottomNavigationBar เพื่อให้ดูสวยงาม
      height: kBottomNavigationBarHeight,
      // กำหนดสีตามที่คุณต้องการ
      color: Colors.deepPurple[800],
    );
  }
}