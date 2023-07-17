import 'package:flutter/material.dart';
import 'package:vara/utility/quotes.dart';

class CustomBar extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const CustomBar({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Text(
          quotes[index],
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
