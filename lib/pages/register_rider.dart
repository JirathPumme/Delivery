import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/components/Navigator_back.dart';
import 'package:delivery/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:delivery/components/bottompurple.dart';
import 'dart:developer' as developer;

class RegisterRider extends StatefulWidget {
  const RegisterRider({super.key});

  @override
  State<RegisterRider> createState() => _RegisterRiderState();
}

class _RegisterRiderState extends State<RegisterRider> {
  File? _profileImage;
  File? _vehicleImage;
  var usernameclt = TextEditingController();
  var phone_numclt = TextEditingController();
  var passwordclt = TextEditingController();
  var car_idclt = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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
      appBar: CustomAppBar(title: ''),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 0),

                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),

                const Text(''),

                const Text(
                  'Rider',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                _buildTextField(label: 'ชื่อ', textcontroll: usernameclt),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'หมายเลขโทรศัพท์',
                  keyboardType: TextInputType.phone,
                  textcontroll: phone_numclt,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'รหัสผ่าน',
                  obscureText: true,
                  textcontroll: passwordclt,
                ),
                const SizedBox(height: 16),
                _buildTextField(label: 'ทะเบียนรถ', textcontroll: car_idclt),
                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'รูปยานพาหนะ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide.none,
                  ),
                  onPressed: _pickVehicleImage,
                  child: Text(
                    _vehicleImage == null ? 'เลือกรูป' : 'เปลี่ยนรูป',
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ),

                if (_vehicleImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _vehicleImage!.path.split('/').last,
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        showdata();
                        if (await regisRider()) {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );                          
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade400,
                      ),
                      child: Text(
                        'สมัครสมาชิก',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade400,
                      ),
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

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

  // Widget Textfield
  Widget _buildTextField({
    required String label,
    bool obscureText = false,
    required TextEditingController textcontroll,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          controller: textcontroll,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  showdata() {
    var uname = usernameclt.text;
    var phone = phone_numclt.text;
    var pass = passwordclt.text;
    var car = car_idclt.text;
    if (uname != "" && phone != "" && pass != "" && car != "") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> regisRider() async {
    if (showdata()) {
      try {
        await FirebaseFirestore.instance.collection("Riders").add({
          "username": usernameclt.text,
          "phone_number": phone_numclt.text,
          "password": passwordclt.text,
          "car_ID": car_idclt.text,
          "role_id": 2,
        });
        const snackBar = SnackBar(
          content: Text(
            'สมัครสมาชิกสำเร็จ',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return true;
      } catch (err) {
        developer.log(err.toString());
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ข้อมูลไม่ครบถ้วน!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
  }
}
