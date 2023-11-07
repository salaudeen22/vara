import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vara/child/bottom_screen/child_home_screen.dart';
import 'package:vara/child//login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vara/db/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vara/parent/parent_homescreen.dart';
import 'package:vara/db/shared_pref.dart';
import 'package:vara/child/bottom_page.dart';
import 'package:vara/parent/parent_homescreen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MySharedPrefences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Women_Safety',
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansExtraCondensedTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: MySharedPrefences.getUserType() == 'child'
          ? BottomPage()
          : (MySharedPrefences.getUserType() == 'parent'
          ? BottomPage()
          : LoginScreen()),
    );
  }
}




