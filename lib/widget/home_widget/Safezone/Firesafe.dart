import 'package:flutter/material.dart';

class Firesafe extends StatelessWidget {
  final Function(String)? onmapFunction; // added missing type and question mark
  const Firesafe({Key? key, this.onmapFunction}) : super(key: key);// added constructor

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onmapFunction?.call("fire station near me"); // added ?.call and a sample search query
      },
      child: Container( // added child property to Container
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.deepPurpleAccent,
              child: Image.asset(
                "images/fire.png",
              ),
            ),
            Text("Fire Station"),
          ],
        ),
      ),
    );
  }
}
