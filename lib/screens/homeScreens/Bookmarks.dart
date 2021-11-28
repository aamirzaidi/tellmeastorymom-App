import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CommonCardViewScreen.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/providers/userData.dart';

//class BookMarkScreen extends StatefulWidget {
//  @override
//  _BookMarkScreenState createState() => _BookMarkScreenState();
//}
//
//FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//
//class _BookMarkScreenState extends State<BookMarkScreen> {
//  @override
//  Widget build(BuildContext context) {
//    // Size size = MediaQuery.of(context).size;
//    return StreamBuilder<QuerySnapshot>(
//      stream: firebaseFirestore.collection("Stories").snapshots(),
//      builder: (context, snapshot) {
//        bookmarkedStories.clear();
//        if (snapshot.hasData)
//          snapshot.data.docs.forEach((result) {
//            List<String> bookmarkListData = result.data()["isBookmarked"] == null ? [] : result.data()["isBookmarked"].cast<String>();
//            if (bookmarkListData.contains(UserData.getUserId())) bookmarkedStories.add(StoryData.fromSnapshot(result));
//          });
//        return CommonCardViewScreen(
//          storyList: bookmarkedStories,
//        );
//      },
//    );
//  }
//}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CommonCardViewScreen.dart';
import 'package:tellmeastorymom/commonWidgets/SearchScreen.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/providers/userData.dart';

class BookMarkScreen extends StatefulWidget {
  @override
  _BookMarkScreenState createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
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
        appBar: appBarOverall(
            heading: "Bookmarks",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            }),
        body: StreamBuilder<QuerySnapshot>(
          stream: firebaseFirestore.collection("Stories").snapshots(),
          builder: (context, snapshot) {
            bookmarkedStories.clear();
            if (snapshot.hasData)
              snapshot.data.docs.forEach((result) {
                List<String> bookmarkListData;
                try{
                  bookmarkListData = result.get("isBookmarked") == null ? [] : result.get("isBookmarked").cast<String>();
                }catch(e){
                  bookmarkListData = [];
                }

                if (bookmarkListData.contains(UserData.getUserId())) bookmarkedStories.add(StoryData.fromSnapshot(result));
              });
            return CommonCardViewScreen(
              storyList: bookmarkedStories,
            );
          },
        ),
      ),
    );
  }
}
