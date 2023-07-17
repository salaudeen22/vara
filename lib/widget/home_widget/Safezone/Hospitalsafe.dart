import 'package:flutter/material.dart';

class Hospitalsafe extends StatelessWidget {
  final Function? onmapFunction;
  const Hospitalsafe({Key? key, this.onmapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onmapFunction?.call("Hospital near me");
      }, // added missing comma
      child: Container(
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.deepPurpleAccent,
              child: Image.asset(
                "images/logo3.png",
              ),
            ),
            Text("Hospital"),
          ],
        ),
      ), // added missing comma
    );
  }
}
