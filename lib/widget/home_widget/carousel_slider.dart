import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vara/utility/quotes.dart';

class CustomCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Achievements",
              style: TextStyle(
                wordSpacing: 50.0,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
        Container(
          padding: EdgeInsets.all(5.0),
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 2.0,
              autoPlay: true,
            ),
            items: List.generate(
              image_slider.length,
              (index) => Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: NetworkImage(image_slider[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
