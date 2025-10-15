import 'package:delivery/components/Navigator_back.dart';
import 'package:delivery/pages/Login.dart';
import 'package:delivery/pages/register_rider.dart';
import 'package:delivery/pages/register_user.dart';
import 'package:flutter/material.dart';
import 'package:delivery/components/bottompurple.dart';

class SelectUserrider extends StatefulWidget {
  const SelectUserrider({super.key});

  @override
  State<SelectUserrider> createState() => _SelectUserriderState();
}

class _SelectUserriderState extends State<SelectUserrider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor: Colors.indigo[600],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/Logosuper_guts.png',
                    width: 300,
                    height: 300,
                  )
                ],
              ),

              const SizedBox(height: 0,),

              Padding(
                padding: const EdgeInsets.fromLTRB(40,0,40,0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed:()
                    {
                      Navigator.push
                        (
                         context,
                         MaterialPageRoute(builder: (context) => const RegisterUser()),
                        );
                    }, 
                    child: const Text(
                      'User',
                      style: TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.fromLTRB(40,10,40,0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                       Navigator.push
                        (
                         context,
                         MaterialPageRoute(builder: (context) => const RegisterRider()),
                        );
                    },
                    child: const Text(
                      'Rider',
                      style: TextStyle(fontSize: 25, color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'หากมีบัญชีอยู่แล้ว',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push
                        (
                         context,
                         MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                    },
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const DecorativeBottomBar(),
    );
  }
}