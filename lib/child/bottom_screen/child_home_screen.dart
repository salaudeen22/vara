import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart' ;
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
import 'package:vara/child/bottom_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _getRandomQuoteIndex();
    _getCurrentLocation();
    _getPermission();


    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        if (mounted) {
          _getAndsentsms();
          print("shake!!!!");
          _scaffoldKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text('Shake!'),
            ),
          );
          // Do stuff on phone shake
        }
      },
      minimumShakeCount: 3,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

    _getPermission() async => await[Permission.sms].request();

    _isPermissionGranted() async => await Permission.sms.status.isGranted;
    _sendSms(String phoneNumber, String message, {int? simSlot}) async {
      SmsStatus result = await BackgroundSms.sendMessage(
          phoneNumber: phoneNumber, message: message, simSlot: 1);
      if (result == SmsStatus.sent) {
        print("Sent");
        Fluttertoast.showToast(msg: "send");
      } else {
        Fluttertoast.showToast(msg: "failed");
      }
    }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }


    _getCurrentLocation() async {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) return;
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true)
          .then((Position position) {
        setState(() {
          _curentPosition = position;
          print(_curentPosition!.latitude);
          _getAddressFromLatLon();
        });
      }).catchError((e) {
        Fluttertoast.showToast(msg: e.toString());
      });
    }

    _getAddressFromLatLon() async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _curentPosition!.latitude, _curentPosition!.longitude);

        Placemark place = placemarks[0];
        setState(() {
          _curentAddress =
          "${place.locality},${place.postalCode},${place.street},";
        });
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
    _getAndsentsms() async
    {
      List<TContact> contactList = await DatabaseHelper()
          .getContactList();
      print(contactList);
      Fluttertoast.showToast(msg: "sending");

      String messageBody = "https://maps.google.com/?daddr=${_curentPosition!
          .latitude},${_curentPosition!.longitude}";

      if (await _isPermissionGranted()) {
        for (var contact in contactList) {
          print('Contact Name: ${contact.name}');
          print('Contact Number: ${contact.number}');

          if (contact.number != null &&
              contact.number.isNotEmpty) {
            telephony.Telephony.instance.sendSms(
                to: contact.number!,
                message: "I am in trouble, please reach me at $messageBody"
            );
            Fluttertoast.showToast(msg: "Message sent to ${contact
                .name}");
          } else {
            Fluttertoast.showToast(
                msg: "Failed to send to ${contact
                    .name}: Contact number is null or empty");
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
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
        key: _scaffoldKey,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SingleChildScrollView(child: Column(
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
          ),


        ),
      );
    }
  }


