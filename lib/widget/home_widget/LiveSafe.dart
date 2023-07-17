import 'package:flutter/material.dart';
import 'package:vara/widget/home_widget/Safezone/Pertol.dart';
import 'package:vara/widget/home_widget/Safezone/Policezone.dart';
import 'package:flutter/material.dart';
import 'package:vara/widget/home_widget/Safezone/Policezone.dart';
import 'package:vara/widget/home_widget/Safezone/Pertol.dart';
import 'package:vara/widget/home_widget/Safezone/Hospitalsafe.dart';
import 'package:vara/widget/home_widget/Safezone/Firesafe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
class LiveSafe extends StatelessWidget {

  static Future<void> openMaps(String location)async
  {
    String googleurl="https://www.google.com/maps/search/$location";
    final Uri _url = Uri.parse(googleurl);
    try
        {
          await launchUrl(_url);
        }
        catch(e)
    {
      Toast.show("Something went wrong! call emergency ");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Police(onmapFunction: openMaps),
          ),

          Padding(
            padding: EdgeInsets.all(4.0),
            child: Pertol(onmapFunction: openMaps),
          ),

          Padding(
            padding: EdgeInsets.all(4.0),
            child: Hospitalsafe(onmapFunction: openMaps),
          ),

          Padding(
            padding: EdgeInsets.all(4.0),
            child: Firesafe(onmapFunction: openMaps),
          ),

        ],
      ),
    );
  }
}
