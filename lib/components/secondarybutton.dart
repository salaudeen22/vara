import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed; // Use VoidCallback instead of function
  const SecondaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: TextButton(
        onPressed: onPressed,
        child: Text(title,style: TextStyle(fontSize: 18),),
      ),
    );
  }
}
