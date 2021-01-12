import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/userData.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // appBarOverall(heading: 'Profile'),
            profilePageAppBar(),
            profileDataList(
              userEmail: UserData.getUserEmail(),
              userName: UserData.getUserName(),
              userPhone: UserData.getUserPhone(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget profilePageAppBar() {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize:
          Size.fromHeight(221.0 * ScreenSize.heightMultiplyingFactor),
      child: appBarOverall(heading: 'Profile', searchThere: false),
    ),
  );
}

Widget profileDataList(
    {String userName = 'UserName',
    String userEmail = 'user@email',
    String userPhone = '+91-9876543210',
    String userImageAsset = 'assets/images/profileImage.png'}) {
  print('width' +
      (ScreenSize.pwidth * ScreenSize.widthMultiplyingFactor).toString());
  return Positioned(
    top: 135.0 * ScreenSize.heightMultiplyingFactor,
    left: 1,
    right: 1,
    child: Center(
      child: Column(
        children: [
          Container(
            width: 335.0 * ScreenSize.widthMultiplyingFactor,
            height: 262.0 * ScreenSize.heightMultiplyingFactor,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              elevation: 3.0 * ScreenSize.heightMultiplyingFactor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 50.0,
                    child: Image.asset(
                      userImageAsset,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 11.0 * ScreenSize.heightMultiplyingFactor,
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 36.0 * ScreenSize.heightMultiplyingFactor,
          ),
          smallBox(Icons.mail_outline, userEmail),
          SizedBox(
            height: 20.0 * ScreenSize.heightMultiplyingFactor,
          ),
          smallBox(Icons.phone, userPhone),
        ],
      ),
    ),
  );
}

Widget smallBox(IconData iconDataPrefix, String title) {
  return Container(
    width: 335.0 * ScreenSize.widthMultiplyingFactor,
    padding: EdgeInsets.fromLTRB(
      22.0 * ScreenSize.widthMultiplyingFactor,
      15.0 * ScreenSize.heightMultiplyingFactor,
      22.0 * ScreenSize.widthMultiplyingFactor,
      15.0 * ScreenSize.heightMultiplyingFactor,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
      border: Border.all(
        color: Color(0xFFE9E9E9),
        width: 1.0,
      ),
      color: Colors.white,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          iconDataPrefix,
          color: primaryColour,
          size: 23.0 * ScreenSize.heightMultiplyingFactor,
        ),
        SizedBox(
          width: 13.0 * ScreenSize.widthMultiplyingFactor,
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 16.0 * ScreenSize.heightMultiplyingFactor,
          ),
        ),
      ],
    ),
  );
}
