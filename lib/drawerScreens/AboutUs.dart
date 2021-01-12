import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        // height: 775 * ScreenSize.heightMultiplyingFactor,
        // width: 411 * ScreenSize.widthMultiplyingFactor,
        child: Stack(
          children: [
            aboutUsAppBar(),
            Positioned(
              top: 100.0 * ScreenSize.heightMultiplyingFactor,
              left: 1,
              right: 1,
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
                      child: Image.asset(
                        "assets/images/SmallLogo.jpg",
                        height: 248 * ScreenSize.heightMultiplyingFactor,
                        width: 206 * ScreenSize.widthMultiplyingFactor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 370.0 * ScreenSize.heightMultiplyingFactor,
              left: 1,
              right: 1,
              child: AboutUsData(),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsData extends StatelessWidget {
  final List<String> names = [
    "Darshil Chheda",
    "Subrat Singhal",
    "Ashish Kumar",
    "Mohd Aamir",
    "Spandan Joshi",
    "Anshul Sharma",
    "Ridhi Jain"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (775 - 340) * ScreenSize.heightMultiplyingFactor,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.0 * ScreenSize.widthMultiplyingFactor,
            0.0, 20.0 * ScreenSize.widthMultiplyingFactor, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(
            //   height: 450 * ScreenSize.heightMultiplyingFactor,
            // ),
           /* Text(
              "\nAbout the App: \n",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                fontFamily: 'Poppins-SemiBold',
              ),
            ),*/
            Text(
              "\nHello, welcome to Tellmeastorymom. \n\nI'm Sweta, founder of Tellmeastorymom. Currently, I am living in Singapore with my Husband and a cute little daughter."
              "I am an IT professional and currently working in Singapore. My roots are from a small city in Madhya Pradesh (India). \n\nTellmeastorymom is my passion. I started it as my hobby in December 2016, but now it’s like my second child."
              "\n\nMy daughter is the inspiration behind this whole idea. Because of her, I realized that stories play an important role in the overall development of a child.\n\n If you have good and meaningful story for a certain topic, then your child will learn that topic very easily. But to have stories on your fingertips is also very difficult, because we have lots of other things in our mind, so it’s really difficult to recall all the stories when your little one want you to narrate."
              "\n\nSo here I come up with the idea of Tellmeastorymom as a solution for all those mothers (fathers too) who struggle to find an apt story for their little one. It’s an online platform to share short and sweet stories for kids and teens.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                fontFamily: 'Poppins-Light',
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 15.0,),
            CircleAvatar(
              backgroundColor: primaryColour,
              radius: 100.0,
              backgroundImage: AssetImage("assets/images/client.jpg"),
            ),
            RichText(
              text: TextSpan(
                children: [

                  TextSpan(
                    text: "\n\nName: Sweta \n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                  TextSpan(
                    text: "Email-ID: tellmeastorymom28@gmail.com\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                  TextSpan(
                    text:
                        "\nDevelopers Involved for building this Application:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                      fontFamily: 'Poppins-SemiBold',
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: names.length,
              itemBuilder: (context, index) {
                return Text(
                  names[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                    fontFamily: 'Poppins-Regular',
                  ),
                );
              },
            ),
            Center(
              child: Text(
                "\nDeveloped with ❤ by Team Naaniz",
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontSize: 12 * ScreenSize.heightMultiplyingFactor,
                  fontFamily: 'Poppins-Light',
                ),
              ),
            ),
            SizedBox(
              height: 10.0 * ScreenSize.heightMultiplyingFactor,
            ),
          ],
        ),
      ),
    );
  }
}

Widget aboutUsAppBar() {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize:
          Size.fromHeight(221.0 * ScreenSize.heightMultiplyingFactor),
      child: appBarOverall(heading: 'About Us', searchThere: false),
    ),
  );
}
