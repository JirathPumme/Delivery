//import 'dart:developer';
import 'package:delivery/Session/User_session.dart';
import 'package:delivery/config/Apptheme.dart';
import 'package:delivery/pages/register_user.dart';
import 'package:delivery/pages/rider_main_screen.dart';
import 'package:delivery/pages/select_user.rider.dart';
import 'package:delivery/pages/user_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delivery/components/bottompurple.dart';
import 'package:delivery/pages/home_user.dart';
import 'package:delivery/pages/home_rider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;
import 'package:delivery/model/user_data_list.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  final String correctUserPhone = '9999';
  final String correctUserPassword = '9999';

  final String correctRiderPhone = '8888';
  final String correctRiderPassword = '8888';
  List<UserDataList> userdata = [];

  Future<void> queryDataFromCollection(String collectionName) async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        collectionName,
      );

      QuerySnapshot querySnapshot = await collectionRef.get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Pass doc.id into fromJson
        UserDataList user = UserDataList.fromJson(data, docId: doc.id);

        userdata.add(user);
        developer.log('✅ (id: ${user.id})');
      }

      developer.log('Total users fetched: ${userdata.length}');
    } catch (e) {
      developer.log('Error querying data: $e');
    }
  }

  Future<void> queryRider() async {
    String collectionName = "Riders";
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(
      collectionName,
    );

    QuerySnapshot querySnapshot = await collectionRef.get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      UserDataList user = UserDataList.fromJson(data, docId: doc.id);

      userdata.add(user);
      developer.log('✅ (id: ${user.id})');
      // developer.log(data["phone_number"]);
      // developer.log(data["password"]);
    }
  }

  Future<void> _login() async {
    String phone = _phoneController.text;
    String password = _passwordController.text;
    bool userlogin = false;
    bool riderlogin = false;
    UserSession user_session;

    userdata.clear();
    await queryDataFromCollection('Users');
    await queryRider();

    if (!mounted) return;

    for (var user in userdata) {
      if (user.id != null) {
        // developer.log(user.id.toString());
        if (user.phoneNumber == phone && user.password == password) {
          user_session = UserSession(user_table: user.id, role_id: user.roleId);
          await SessionManager().set("User", user_session);
          if (user.roleId == 1) {
            userlogin = true;
          } else {
            riderlogin = true;
          }
          break;
        }
      }
    }
    // return;

    if (userlogin) {
      setState(() {
        _errorText = null;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserMainScreen()),
      );
    } else if (riderlogin) {
      setState(() {
        _errorText = null;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RiderMainScreen()),
      );
    } else {
      final snackBar = SnackBar(
        content: const Text('หมายเลขโทรศัพท์หรือรหัสผ่านไม่ถูกต้อง'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      body: SafeArea(
        //child:Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/Logosuper_guts.png',
                    width: 300,
                    height: 300,
                  ),
                ],
              ),

              const SizedBox(height: 0),

              /*Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Delivery',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),*/

              //const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username
                  Text(
                    " หมายเลขโทรศัพท์",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 10),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  Text(
                    " Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SelectUserrider(),
                            ),
                          );
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

                      ElevatedButton(
                        onPressed: _login,
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
