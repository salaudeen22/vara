import 'package:flutter/material.dart';
import 'package:vara/widget/home_widget/emergencies/policeemergency.dart';
import 'emergencies/ambulance.dart';
import 'emergencies/hosptial.dart';

class Emergency extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceEmergency(),
          Ambulance(),
          Hospital(),

        ],
      ),
    );
  }
}