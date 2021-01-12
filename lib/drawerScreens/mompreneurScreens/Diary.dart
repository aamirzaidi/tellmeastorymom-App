import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/HomeScreenCardView.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

class Diary extends StatefulWidget {
  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 15.0 * ScreenSize.heightMultiplyingFactor,
      ),
      child: ListView(
        children: [
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
            isDiary: true,
          ),
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
            isDiary: true,
          ),
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
            isDiary: true,
          ),
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
            isDiary: true,
          ),
          HomeScreenCardView(
            boxHeight: 230 * ScreenSize.heightMultiplyingFactor,
            insideHeight: 180 * ScreenSize.heightMultiplyingFactor,
            insideWidth: 345 * ScreenSize.widthMultiplyingFactor,
            storyList: [popularStories[0]],
            itemCard: false,
            isInterview: true,
            isDiary: true,
          ),
        ],
      ),
    );
  }
}
