import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'screens/SplashScreen.dart';

int initScreen3;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen3 = prefs.getInt("initScreen3");
  await Firebase.initializeApp();
  runApp(AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // precacheImage(
    //     AssetImage(
    //       'assets/images/splashScreen.png',
    //     ),
    //     context);
    precacheImage(
        AssetImage(
          'assets/images/googleIcon.png',
        ),
        context);
    precacheImage(
        AssetImage(
          'assets/images/profileImage.png',
        ),
        context);
    precacheImage(
        AssetImage(
          'assets/images/shareImage.png',
        ),
        context);

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: 1.0, alwaysUse24HourFormat: false),
          child: child,
        );
      },
      theme: ThemeData(
        primaryColor: Color(0xFF0F2985),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
