// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
import 'dart:io';
import 'package:delivery/components/Navigator_back.dart';
import 'package:delivery/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:delivery/components/bottompurple.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _gpsController = TextEditingController();
  var username = TextEditingController();
  var password = TextEditingController();
  var phone_num = TextEditingController();
  var address = TextEditingController();

   Future<void> _pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> addTestData() async {
    await FirebaseFirestore.instance.collection('test').add({
      'message': 'Hello Firestore!',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addUser(
    String username,
    String password,
    String phone,
    String address,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('Users').add({
        'username': username,
        'password': password,
        'phone_number': phone,
        'address': address,
        'role_id': 1,
      });
    } catch (err) {
      developer.log(err.toString());
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _gpsController.text = '${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
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
      backgroundColor: Colors.indigo[600],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GestureDetector(
                onTap: _pickProfileImage,
                child : CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),

              const Text(''),

                const Text(
                  'User',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                _buildTextField('ชื่อ', username),
                const SizedBox(height: 16),
                _buildTextField('รหัสผ่าน', password, isObscure: true),
                const SizedBox(height: 16),
                _buildTextField('หมายเลขโทรศัพท์', phone_num),
                const SizedBox(height: 16),
                _buildTextField('ที่อยู่', address),
                const SizedBox(height: 16),

                _buildGpsTextField(),

                const Text(''),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        register();

                        //   const snackBar = SnackBar(
                        //   content: Text(
                        //     'สมัครสมาชิกสำเร็จ',
                        //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        //   ),
                        //   backgroundColor: Colors.green,
                        //   duration: Duration(seconds: 3),
                        // );

                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Widget _buildTextField(
    String label,
    TextEditingController textcontroller, {
    bool isObscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          controller: textcontroller,
          obscureText: isObscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  // --- เอาฟังก์ชันนี้ไปแทนที่ของเก่า! ---
Widget _buildGpsTextField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'พิกัด GPS',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _gpsController, // 1. ผูก Controller ไว้แสดงผล
        readOnly: true, // 2. ทำให้ผู้ใช้พิมพ์เองไม่ได้!
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'กดปุ่มเพื่อดึงตำแหน่ง',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          // --- 3. ติดตั้ง 'ไกปืน' (IconButton) ---
          suffixIcon: IconButton(
            icon: const Icon(Icons.my_location, color: Color(0xFF5B4FBF)),
            onPressed: _getCurrentLocation,
          ),
        ),
      ),
    ],
  );
}

  Future<void> register() async {
    var username_t = username.text.trim();
    var password_t = password.text.trim();
    var phone_t = phone_num.text.trim();
    var address_t = address.text.trim();

    if (username_t.isEmpty ||
        password_t.isEmpty ||
        phone_t.isEmpty ||
        address_t.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบทุกช่อง'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Log to console for now
    developer.log("Username: $username_t");
    developer.log("Password: $password_t");
    developer.log("Phone: $phone_t");
    developer.log("Address: $address_t");


    // addTestData();


    if (await ishave(phone_t)) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'เบอร์มือถือซ้ำ!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        duration: Duration(seconds: 3),
      ),
    );
    }else {
    addUser(username_t, password_t, phone_t, address_t);  
    // Show success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'สมัครสมาชิกสำเร็จ!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
    }

  }

  //เวอร์ชันอัพเกรด ลองๆ
  /*Future<bool> ishave(String user_number) async {
  try {
    // สั่งให้ Firestore ค้นหา User ที่มี 'phone_number' ตรงกัน
  final query = await FirebaseFirestore.instance
      .collection("Users")
      .where("phone_number", isEqualTo: user_number)
      .limit(1) // หาเจอแค่ 1 คนก็พอแล้ว!
      .get();

  // ถ้าผลลัพธ์ที่ได้กลับมาไม่ว่างเปล่า ก็แปลว่า 'มี' ซ้ำ!
  if (query.docs.isNotEmpty) {
    developer.log('พบเบอร์โทรศัพท์ซ้ำ: $user_number');
    return true;
  }
  } catch (e) {
    developer.log('Error querying data: $e');
  } 

  return false;
}*/

 // หลักๆที่อาร์มทํา
 Future<bool> ishave(String user_number) async {
  try {
    // 1. Get a reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection("Users");

    // 2. Execute the query to get all documents
    QuerySnapshot querySnapshot = await collectionRef.get();

    // 3. Process the documents
    if (querySnapshot.docs.isNotEmpty) {
      developer.log('Documents in collection Users:');
      for (var doc in querySnapshot.docs) {
        final Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;
        final username = documentData['username'];
        final phone = documentData['phone_number'];
        // Access the document data using doc.data()
        // doc.id is the document ID
        if (user_number == phone) {
          return true;
        }
        developer.log('Document ID: ${doc.id} ,Name: $username, Phone: $phone');
      }
    } else {
      developer.log('No documents found in collection Users.');
    }
  } catch (e) {
    developer.log('Error querying data: $e');
  }

  return false;
 }

 Future<void> queryDataFromCollection(String collectionName) async {
  try {
    // 1. Get a reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionName);

    // 2. Execute the query to get all documents
    QuerySnapshot querySnapshot = await collectionRef.get();

    // 3. Process the documents
    if (querySnapshot.docs.isNotEmpty) {
      print('Documents in collection "$collectionName":');
      for (var doc in querySnapshot.docs) {
        final Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;
        final username = documentData['username'];
        // Access the document data using doc.data()
        // doc.id is the document ID
        print('Document ID: ${doc.id},Name: $username');
      }
    } else {
      print('No documents found in collection "$collectionName".');
    }
  } catch (e) {
    print('Error querying data: $e');
  }
}
}
