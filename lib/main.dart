import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newproject/Utiles/Colors.dart';
import 'package:newproject/Utiles/constants.dart';
import 'package:newproject/pages/bottomNavigation.dart';
import 'package:newproject/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return OverlaySupport(
      child: MaterialApp(
        title: 'My Office',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Splash(),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    _checkShared();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Image.asset(
                    "Images/login/logo21.png",
                    width: Constants().containerWidth(context) * 0.6,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Constants.selectedFontWidget(
                  "Powered by TrioSolve",
                  ColorsUsed.textBlueColor,
                  Constants().containerWidth(context) * 0.045,
                  FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _checkShared() async {
    print(await _firebaseMessaging.getToken());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String id = prefs.getString('USERID') ?? '';
    Constants.userId = id;

    if (Constants.userId == '') {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigation()));
      });
    }
  }
}
