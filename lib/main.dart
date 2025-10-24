import 'package:delivery/firebase_options.dart';
import 'package:delivery/pages/google_map_screen.dart';
import 'package:delivery/pages/home_rider.dart';
import 'package:delivery/pages/home_user.dart';
import 'package:delivery/pages/profile_rider.dart';
import 'package:delivery/pages/profile_user.dart';
import 'package:delivery/pages/register_rider.dart';
import 'package:delivery/pages/register_user.dart';
import 'package:delivery/pages/rider_main_screen.dart';
import 'package:delivery/pages/rider_map.dart';
import 'package:delivery/pages/select_user.rider.dart';
import 'package:delivery/pages/testgps.dart';
import 'package:delivery/pages/user_main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:delivery/pages/Login.dart';
import 'package:delivery/pages/Splash_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:delivery/config/Apptheme.dart';
import 'package:google_fonts/google_fonts.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
  theme: ThemeData(
    textTheme: GoogleFonts.notoSansThaiTextTheme() 
  ),
  title: '',
  // home: const MyApp(),
  initialRoute: '/user_main_screen',
  routes: {
    '/splash': (context) => const Splash_Page(),
    '/login': (context) => const LoginPage(),
    //   initialRoute: '/testgps',
    //'/homeuser': (context) => const HomeUser(),
    //'/homerider': (context) => const HomeRider(),
    '/register_user': (context) => const RegisterUser(),
    '/selectuser_rider': (context) => const SelectUserrider(),
    '/register_rider': (context) => const RegisterRider(),
    '/user_main_screen': (context) => const UserMainScreen(),
    '/rider_main_screen': (context) => const RiderMainScreen(),
    '/profile_rider': (context) => const ProfileRider(),
    '/profile_user': (context) => const ProfileUser(),
    '/testgps': (context) => const Testgps(),
    '/google_map': (context) => const GoogleMapScreen(),
    '/google_map': (context) => const GoogleMapScreen(),
    },
  );
 } 
}
