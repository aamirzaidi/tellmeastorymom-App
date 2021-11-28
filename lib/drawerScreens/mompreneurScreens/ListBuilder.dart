import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/HomeScreenCardView.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

class ListBuilder extends StatelessWidget {
  final List<StoryData> storyList;
  final bool isDiary;
  ListBuilder({@required this.storyList, this.isDiary = false});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.white,
      height: size.height,
      child: (storyList == null || storyList.length == 0)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/noStories.png',
                  height: 243 * ScreenSize.heightMultiplyingFactor,
                  width: 243 * ScreenSize.widthMultiplyingFactor,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0 * ScreenSize.heightMultiplyingFactor,
                  ),
                  child: Text(
                    isDiary == false ? "No Interviews to display!!" : "No Diaries to display!!",
                    style: TextStyle(
                      fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
                      fontFamily: 'Poppins-SemiBold',
                      color: primaryColour,
                    ),
                  ),
                ),
              ],
            )
          : Container(
              margin: EdgeInsets.only(
                top: 20.0 * ScreenSize.heightMultiplyingFactor,
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: physicsForApp,
                itemCount: storyList.length,
                itemBuilder: (context, index) {
                  print('working here');
                  return HomeScreenCardView(
                    boxHeight: 250 * ScreenSize.heightMultiplyingFactor,
                    insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
                    insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
                    storyList: [storyList[index]],
//                    isInterview: true,
//                    isDiary: this.isDiary,
                  );
                },
              ),
            ),
    );
  }
}
