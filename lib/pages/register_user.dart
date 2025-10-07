import 'package:delivery/components/Navigator_back.dart';
import 'package:delivery/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:delivery/components/bottompurple.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  
  final TextEditingController _gpsController = TextEditingController();

  Future<void> _getCurrentLocation() async {
    try {

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _gpsController.text = '${position.latitude}, ${position.longitude}';
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  @override
  void dispose() {
    _gpsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      backgroundColor:  Colors.indigo[600],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(''),
                  backgroundColor: Colors.deepOrangeAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'User',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                _buildTextField('ชื่อ'),
                const SizedBox(height: 16),
                _buildTextField('รหัสผ่าน', isObscure: true),
                const SizedBox(height: 16),
                _buildTextField('หมายเลขโทรศัพท์'),
                const SizedBox(height: 16),
                _buildTextField('ที่อยู่'),
                const SizedBox(height: 16),

                _buildGpsTextField(),

                const Text(''),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  ElevatedButton(
                     onPressed:()
                     {
                        const snackBar = SnackBar(
                        content: Text(
                          'สมัครสมาชิกสำเร็จ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     },
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade400
                     ),
                     child: Text('สมัครสมาชิก',style: 
                     TextStyle(fontWeight: FontWeight.bold,fontSize: 22))),
                const SizedBox(height: 20),

                ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push
                        (
                         context,
                         MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade400,
                      ),
                     child: Text('เข้าสู่ระบบ',style:
                     TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)),
                    ]                 
                  ),      
                const SizedBox(height: 24),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('หากมีบัญชีอยู่แล้ว?', style: TextStyle(color: Colors.white70)),
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
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),*/
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const DecorativeBottomBar(),
    );
  }

  Widget _buildTextField(String label, {bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: isObscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildGpsTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'พิกัด GPS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _gpsController,
          readOnly: true, 
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            // เพิ่มไอคอนท้ายช่อง
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location, color: Color(0xFF5B4FBF)),
              onPressed: _getCurrentLocation, 
            ),
          ),
        ),
      ],
    );
  }
}