import 'package:delivery/pages/Login.dart';
import 'package:delivery/pages/profile_rider_fix.dart';
import 'package:delivery/pages/profile_user_fix.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
class SettingPageRider extends StatefulWidget {
  const SettingPageRider({super.key});

  @override
  State<SettingPageRider> createState() => _SettingPageRiderState();
}

class _SettingPageRiderState extends State<SettingPageRider> {
 
  bool isFirst = true;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    
                    //const SizedBox(height: 40),
                    
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileRiderFix(),
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
                Column(
                  children: [
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                              onPressed: () {
                              // TODO:  Firebase signOut()
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[500],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'ออกจากระบบ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ],
                )
                  
              ],
            ),
          
        ),
      ),
    );
  }
}


void logout() {
  developer.log("Logout button work!!");
}