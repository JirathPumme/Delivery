import 'dart:io';
import 'package:delivery/pages/profile_user_fix.dart';
import 'package:flutter/material.dart';
import 'package:delivery/components/bottompurple.dart';
import 'package:delivery/components/backbutton.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:developer' as developer;
class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  File? _profileImage;
  File? _vehicleImage;
  final ImagePicker _picker = ImagePicker();

    // Start with the first image
  String imageUrl = 'https://popcat.click/twitter-card.jpg';

  // The second image to switch to
  final String altImageUrl = 'https://i.imgur.com/HXKZ5G5.png';

  bool isFirst = true;

  Future<void> _pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVehicleImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _vehicleImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'User',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileUserFix(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[500],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'แก้ไขโปรไฟล์',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Text("String TEst"),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const DecorativeBottomBar(),
    );
  }
}


void logout() {
  developer.log("Logout button work!!");
}