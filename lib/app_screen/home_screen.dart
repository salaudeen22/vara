import 'dart:math';
import 'package:flutter/material.dart';
import '../widget/home_widget/custom_bar.dart';
import 'package:vara/widget/home_widget/carousel_slider.dart';
import 'package:vara/widget/home_widget/emergency.dart';
import 'package:vara/widget/home_widget/LiveSafe.dart';
import 'package:vara/widget/home_widget/safehome/safehome.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Declare a variable to store the index of the current quote.
  int? currentQuoteIndex;

  // Define a function to generate a random quote index and update the state.
  void _getRandomQuoteIndex() {
    Random random = Random();

    setState(() {
      currentQuoteIndex = random.nextInt(5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Add some padding to the top, bottom, left and right of the screen.
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Add a custom navigation bar at the top of the screen.
              CustomBar(
                  index: currentQuoteIndex ?? 0, onTap: _getRandomQuoteIndex),

              // Add a carousel to display images or videos.
              CustomCarousel(),

              // Add a heading to indicate the Safezone section.
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Safezone",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Add a color to the text.
                  ),
                ),
              ),

              // Add an emergency section to display emergency contacts.
              Emergency(),

              // Add a heading to indicate the Explore SafeZone section.
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Explore SafeZone",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Add a color to the text.
                    ),
                  ),
                ),
              ),

              // Add a section to display LiveSafe information.
              LiveSafe(),


            ],
          ),
        ),
      ),
    );
  }
}
