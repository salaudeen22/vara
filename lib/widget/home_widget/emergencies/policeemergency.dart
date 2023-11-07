import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
class PoliceEmergency extends StatelessWidget {

  Future<void> callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res != null && res) {

    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> callNumber('100'),
        child:Card(
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
                  "images/logo.png",

                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Activate Police Alert",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Call 1-0-0 in case of emergency",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Tap here",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}
