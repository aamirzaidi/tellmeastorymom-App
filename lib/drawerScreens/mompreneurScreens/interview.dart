import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/HomeScreenCardView.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

class Interview extends StatefulWidget {
  @override
  _InterviewState createState() => _InterviewState();
}

class _InterviewState extends State<Interview> {
  @override
  Widget build(BuildContext context) {
    Divider contentDivider = Divider(
      color: primaryColour,
      height: 30,
    );
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 15.0 * ScreenSize.heightMultiplyingFactor,
      ),
      child: ListView(
        children: [
          // ItemImageCard(
          //   assetname: "assets/images/momdemo.png",
          // ),
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
          ),
          contentDivider,
          buildTextPart(),
          contentDivider,
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
          ),
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
          ),
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
          ),
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
          ),
        ],
      ),
    );
  }

  Widget buildTextPart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20.0,
        10.0,
        20.0,
        10.0,
      ),
      child: Text(
        "In this section Mompreneurs , we are sharing interviews with inspiring mompreneurs who are following their passion. Today, we’re talking with Shweta Pratap Singh, A Zumba Education Specialist (ZES). We are grateful for her valuable time as she shared her successes to inspire other mompreneurs & women entrepreneurs around the world.",
        style: TextStyle(
          fontFamily: "Poppins-Light",
          fontSize: 16,
        ),
      ),
    );
  }
}
