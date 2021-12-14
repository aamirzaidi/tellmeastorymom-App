import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/screens/Home.dart';
import 'package:tellmeastorymom/screens/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async {
      ScreenSize(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FirebaseAuth.instance.currentUser == null
              ? LoginScreen()
              : Home(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        resizeToAvoidBottomInset: false,
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size.width,
                child: Center(
                   child: Image(
                     image: AssetImage("assets/images/SmallLogo.png"),
                     fit: BoxFit.scaleDown,
                   ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
