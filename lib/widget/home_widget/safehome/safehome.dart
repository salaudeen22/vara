import 'package:flutter/material.dart';


class SafeHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,


      child:
      Container(
        height: 90,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.5,
        decoration: BoxDecoration(

        ),
        child:
        Row(
          children: [
            ListTile(
              title: Text("Send location"),
            )
          ],
        ),
      ),
    )
    );
  }
}