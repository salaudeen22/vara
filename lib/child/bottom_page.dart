import 'package:flutter/material.dart';
import 'package:vara/child/bottom_screen/acitivitypage.dart';
import 'package:vara/child/bottom_screen/contacts_page.dart';
import 'package:vara/child/bottom_screen/Profile_page.dart';


import 'package:vara/child/bottom_screen/add_contact.dart';
import 'package:vara/child/bottom_screen/acitivitypage.dart';
import 'package:vara/child/bottom_screen/child_home_screen.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int current_index = 0;
  List<Widget> pages = [
    HomeScreen(),
    AddContactPage(),
    Activitypage(),
    ProfilePage(),

  ];

  void onTapped(int index) {
    setState(() {
      current_index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[current_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current_index,
        onTap: onTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "Contact", icon: Icon(Icons.contact_phone)),
          BottomNavigationBarItem(label: "Activity", icon: Icon(Icons.feed)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person))
        ],
      ),
    );
  }
}
