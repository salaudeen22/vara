import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart' as background_sms;
import 'package:telephony/telephony.dart' as telephony;
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vara/db/db_service.dart';
import 'package:vara/model/contactsm.dart';
import 'package:vara/widget/home_widget/custom_bar.dart';
import 'package:vara/widget/home_widget/carousel_slider.dart';
import 'package:vara/widget/home_widget/emergency.dart';
import 'package:vara/widget/home_widget/LiveSafe.dart';
import 'package:vara/widget/home_widget/safehome/safehome.dart';

class ParentHomeScreen extends StatefulWidget {
  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;
  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    _getRandomQuoteIndex();
    _getCurrentLocation();
    _getAddressFromLocation();


    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          _showSnackbar();
        });
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }
  _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shake!'),
        action: SnackBarAction(
          label: 'Send SMS',
          onPressed: () {
            getAndSendSms();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  _getPermission() async {
    await [Permission.sms].request();
  }

  isPermissionGranted() async {
    return await Permission.sms.status.isGranted;
  }

  _sendSms(String phoneNumber, String message) async {
    await background_sms.BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
    ).then((background_sms.SmsStatus status) {
      if (status == background_sms.SmsStatus.sent) {
        Fluttertoast.showToast(msg: "Sent");
      } else {
        Fluttertoast.showToast(msg: "Failed");
      }
    });
  }

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location denied");
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permanently denied");
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _getAddressFromLocation() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.locality}, ${place.postalCode}, ${place.street}';
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAndSendSms() async {
    List<TContact> contactList = await DatabaseHelper().getContactList();
    Fluttertoast.showToast(msg: "sending");
    String messageBody =
        "https://maps.google.com/?daddr=${_currentPosition!.latitude}, ${_currentPosition!.longitude}";
    if (await isPermissionGranted()) {
      contactList.forEach((element) {
        telephony.Telephony.instance.sendSms(
            to: element.number,
            message: "I am in trouble please reach me at $messageBody");
      });
    }
  }

  int? currentQuoteIndex;

  void _getRandomQuoteIndex() {
    Random random = Random();

    setState(() {
      currentQuoteIndex = random.nextInt(5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(child:Column(
            children: [
              CustomBar(
                index: currentQuoteIndex ?? 0,
                onTap: _getRandomQuoteIndex,
              ),
              CustomCarousel(),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Safezone",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Emergency(),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Explore SafeZone",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              LiveSafe(),
              SafeHome(),

            ],
          ),
        ),
        )
      ),
    );
  }
}
