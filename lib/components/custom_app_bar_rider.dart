import 'package:delivery/pages/profile_rider.dart';
import 'package:flutter/material.dart';
import 'package:delivery/pages/profile_user.dart';

class CustomAppBarRider extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarRider({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo[600],
      elevation: 0,
      automaticallyImplyLeading: false,

      title: Row(
        children: [
          Image.asset(
            'images/Logosuper_guts.png',
            height: 50,
          ),
          const SizedBox(width: 20), 
          const Text(
            'Rider (ชื่อ)',
            style: TextStyle(color: Colors.white,
             fontWeight: FontWeight.bold,
             fontSize: 27),
          ),
        ],
      ),

      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white, size: 40),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileRider()),
            );
          },
        ),
        const SizedBox(width: 10), // ระยะห่างจากขอบขวา
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}