import 'package:flutter/material.dart';
import 'package:vara/utility/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed; // Note the lowercase 'f' in 'Function'
  bool loading;

  PrimaryButton({required this.title, required this.onPressed, this.loading = false}); // Fixed syntax

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor:primaryColor, // You should define 'primarycolor'
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
