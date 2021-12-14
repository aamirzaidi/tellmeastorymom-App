import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/drawerScreens/AboutUs.dart';
import 'package:tellmeastorymom/drawerScreens/LikedStories.dart';
import 'package:tellmeastorymom/drawerScreens/MyStories.dart';
import 'package:tellmeastorymom/drawerScreens/ShareWithFriends.dart';
import 'package:tellmeastorymom/drawerScreens/adminArea.dart';
import 'package:tellmeastorymom/drawerScreens/themepage.dart';
import 'package:tellmeastorymom/providers/authService.dart';
import 'package:tellmeastorymom/screens/AddStoryScreens/textScreen.dart';
import 'package:tellmeastorymom/screens/LoginScreen.dart';
import 'package:tellmeastorymom/screens/homeScreens/Bookmarks.dart';
import 'package:tellmeastorymom/providers/userData.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatefulWidget {
  final admin;
  HomeDrawer({@required this.admin});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              18.0 * ScreenSize.widthMultiplyingFactor,
              45.0 * ScreenSize.heightMultiplyingFactor,
              10.0 * ScreenSize.widthMultiplyingFactor,
              45.0 * ScreenSize.heightMultiplyingFactor,
            ),
            decoration: BoxDecoration(
              color: primaryColour,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        backgroundImage: AssetImage('assets/images/peachu.jpg',),
                        radius: 30.0,
                      ),
                      SizedBox(
                        width: 8.0 * ScreenSize.heightMultiplyingFactor,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             "Tellmeastorymom",
                              style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 17.5 *
                                      ScreenSize.heightMultiplyingFactor,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height:
                              1.0 * ScreenSize.heightMultiplyingFactor,
                            ),
                            Text(
                              UserData.getUserName() ?? 'Error',
                              style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 17.0 *
                                      ScreenSize.heightMultiplyingFactor,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height:
                              1.0 * ScreenSize.heightMultiplyingFactor,
                            ),
                            Text(
                              UserData.getUserEmail() ?? '',
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize: 12.0 *
                                    ScreenSize.heightMultiplyingFactor,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MyStories()));
                },
                child: Card(
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 26.0, right: 26, top: 20, bottom: 20),
                    child: Text("My Stories",style: TextStyle(fontFamily: 'Oxygen-Bold'),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => LikedStories()));
                },
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 26.0, right: 26, top: 20, bottom: 20),
                    child: Text("Liked Stories",style: TextStyle(fontFamily: 'Oxygen-Bold'),),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => BookMarkScreen()));
              },
              child: Card(
                elevation: 7,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 26.0, right: 26, top: 20, bottom: 20),
                  child: Text("My Bookmarks",style: TextStyle(fontFamily: 'Oxygen-Bold'),),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              height: 40.0,
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) => Home()));
                },
                leading: Icon(
                  Icons.home,
                  size: 24 * ScreenSize.heightMultiplyingFactor,
                  color: Colors.black,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
                ),
              ),
            ),
          ),
          Container(
            height: 40.0,
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                 Navigator.of(context)
                     .push(MaterialPageRoute(builder: (context) => TextScreen()));

              },
              leading: Icon(
                Icons.notes,
                size: 24 * ScreenSize.heightMultiplyingFactor,
                color: Colors.black,
              ),
              title: Text(
                "Contribute",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
              ),
            ),
          ),
          Container(
            height: 40.0,
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AboutUs()));
              },
              leading: Icon(
                Icons.info_outline,
                color: Colors.black,
                size: 24 * ScreenSize.heightMultiplyingFactor,
              ),
              title: Text(
                "About Us",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
              ),
            ),
          ),
          Container(
            height: 40.0,
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ChangeTheme()));
              },
              leading: Icon(
                Entypo.colours,
                color: Colors.black,
                size: 24 * ScreenSize.heightMultiplyingFactor,
              ),
              title: Text(
                "Change Theme",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
              ),
            ),
          ),
          widget.admin == true ? Container(
            height: 40.0,
            child: ListTile(
              onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => AdminArea()));
              },
              leading: Icon(
                Icons.person,
                size: 24 * ScreenSize.heightMultiplyingFactor,
                color: Colors.black,
              ),
              title: Text(
                "Admin Area",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
              ),
            ),
          ) : SizedBox(),
          Container(
            height: 40.0,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShareWithFriends()));
              },
              leading: Icon(
                Icons.share,
                color: Colors.black,
                size: 24 * ScreenSize.heightMultiplyingFactor,
              ),
              title: Text(
                "Share with friends",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
              ),
            ),
          ),
          Container(
            height: 40.0,
            child: ListTile(
              onTap: () {
                launch(
                    "https://www.tellmeastorymom.com");
              },
              leading: Icon(
                Icons.computer_rounded,
                color: Colors.black,
                size: 24 * ScreenSize.heightMultiplyingFactor,
              ),
              title: Text(
                "Visit Our Website",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
              ),
            ),
          ),
          Container(
            height: 40.0,
            child: ListTile(
              onTap: () async {
                Navigator.pop(context);
                final Email email = Email(
                  recipients: ['tellmeastorymom28@gmail.com'],
                  isHTML: false,
                );

                await FlutterEmailSender.send(email);

              },
              leading: Icon(
                Icons.phone,
                size: 24 * ScreenSize.heightMultiplyingFactor,
                color: Colors.black,
              ),
              title: Text(
                "Contact Us",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
              ),
            ),
          ),
          Spacer(),
          Divider(
            height: 5.0 * ScreenSize.heightMultiplyingFactor,
            thickness: 1.0,
            indent: 15.0 * ScreenSize.widthMultiplyingFactor,
            endIndent: 15.0 * ScreenSize.widthMultiplyingFactor,
            color: Color(0xFF707070),
          ),
          Container(
            height: 40.0,
            child: ListTile(
              onTap: () {
                try {
                  FirebaseAuth.instance.signOut();
                } catch (e) {
                  print(
                      'error in FirebaseAuth.instance.signOut() on pressing logout');
                }
                try {
                  AuthService().signOutGoogle();
                } catch (e) {
                  print(
                      'error in AuthService().signOutGoogle() on pressing logout');
                }

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black,
                size: 24 * ScreenSize.heightMultiplyingFactor,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                    fontFamily: 'Poppins-Regular',
                    fontSize: 18.0 * ScreenSize.heightMultiplyingFactor),
              ),
            ),
          ),
          SizedBox(
            height: 20.0 * ScreenSize.heightMultiplyingFactor,
          ),
        ],
      ),
    );
  }
}


