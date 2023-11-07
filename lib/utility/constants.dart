import 'package:flutter/material.dart';

const Color primaryColor = Color(0xfffc3b77);

void goto(BuildContext context, Widget nxt) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nxt,
      ));
}

dialgoue(BuildContext context, String text) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(text),
          ));
}

Widget Progressindicator(BuildContext context) {
  return (Center(
      child: CircularProgressIndicator(
    color: Colors.pink,
    backgroundColor: Colors.transparent,
  )));
}


