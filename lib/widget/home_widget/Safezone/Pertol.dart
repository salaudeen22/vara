import 'package:flutter/material.dart';

class Pertol extends StatelessWidget {
  final Function? onmapFunction;
  const Pertol({Key? key, this.onmapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onmapFunction?.call("Petrol Station near me");
      }, // added missing comma
      child: Container(
        child: Column(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.deepPurpleAccent,
              child: Image.asset(
                "images/logo2.png",
              ),
            ),
            Text("Petrol Bunk"),
          ],
        ),
      ), // added missing child property
    );
  }
}
