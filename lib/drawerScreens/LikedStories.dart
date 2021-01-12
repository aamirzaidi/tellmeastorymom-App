import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CommonCardViewScreen.dart';
import 'package:tellmeastorymom/commonWidgets/SearchScreen.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/providers/userData.dart';

class LikedStories extends StatefulWidget {
  @override
  _LikedStoriesState createState() => _LikedStoriesState();
}

class _LikedStoriesState extends State<LikedStories> {
  @override
  void initState() {
    super.initState();
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: appBarOverall(
            heading: "Liked Stories",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            }),
        body: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore.collection("Stories").snapshots(),
            builder: (context, snapshot) {
              likedStories.clear();
              if (snapshot.hasData)
                snapshot.data.docs.forEach((result) {
                  List<String> likedListData = result.data()["isLiked"] == null
                      ? []
                      : result.data()["isLiked"].cast<String>();
                  if (likedListData.contains(UserData.getUserId()))
                    likedStories.add(StoryData.fromSnapshot(result));
                });
              return CommonCardViewScreen(
                storyList: likedStories,
              );
            }),
      ),
    );
  }
}
