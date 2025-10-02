//import 'dart:developer';
import 'package:delivery/config/Apptheme.dart';
import 'package:delivery/pages/register_user.dart';
import 'package:delivery/pages/select_user.rider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:delivery/components/bottompurple.dart';
import 'package:delivery/pages/home_user.dart';
import 'package:delivery/pages/้home_rider.dart';

class LoginPage extends StatefulWidget {
  const  LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  final String correctUserPhone = '0855948782';
  final String correctUserPassword = '9999';

  final String correctRiderPhone = '0925190303';
  final String correctRiderPassword = '8888';

  void _login() {
    String phone = _phoneController.text;
    String password = _passwordController.text;

    if (phone == correctUserPhone && password == correctUserPassword) {
      setState(() {
        _errorText = null;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeUser()),
      );
    }

    else if (phone == correctRiderPhone && password == correctRiderPassword) {
      setState(() {
        _errorText = null;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeRider()),
      );
    }
    
    else {
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
        child:SingleChildScrollView(
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
                  style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
			            border:OutlineInputBorder(
                  borderSide: BorderSide(width: 10),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))))
                ),
                const SizedBox(height: 20),

                // Password
                Text(
                  " Password",
                  style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(   
                filled: true,           
                fillColor: Colors.white,
			            border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(width: 1)))
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                     onPressed:()
                     {
                       Navigator.push
                        (
                         context,
                         MaterialPageRoute(builder: (context) => const SelectUserrider()),
                        );
                     },
                     style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade400
                     ),
                     child: Text('สมัครสมาชิก',style: 
                     TextStyle(fontWeight: FontWeight.bold,fontSize: 22))),

                  
 
                    ElevatedButton(
                      onPressed:_login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade400,
                      ),
                     child: Text('เข้าสู่ระบบ',style:
                     TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)),                
                  ]                 
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