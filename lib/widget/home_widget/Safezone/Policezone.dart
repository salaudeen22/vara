import 'package:flutter/material.dart';

class Police extends StatelessWidget {
  final Function? onmapFunction;
  const Police({Key? key, this.onmapFunction}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onmapFunction?.call("Police Station near me");
      }, // added missing comma
      child: Container(
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.deepPurpleAccent,
              child: Image.asset(
                "images/logo.png",
              ),
            ),
            Text("Police Station"),
          ],
        ),
      ), // added missing child property
    );
  }
}
