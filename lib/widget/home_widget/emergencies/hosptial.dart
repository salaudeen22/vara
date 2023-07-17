import 'package:flutter/material.dart';

class Hospital extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 240,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xff870160),
              Color(0xff5b0060),
              Color(0xff870160),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,

                child: Image.asset(
                  "images/logo3.png",

                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alert women safety wing",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Call 1-0-8-0 in case of emergency",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),

                    SizedBox(height: 8),
                    Text(
                      "Direct me",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
