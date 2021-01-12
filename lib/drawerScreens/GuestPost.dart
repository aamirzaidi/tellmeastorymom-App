import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CommonCardViewScreen.dart';
import 'package:tellmeastorymom/commonWidgets/SearchScreen.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

class GuestPost extends StatefulWidget {
  @override
  _GuestPostState createState() => _GuestPostState();
}

class _GuestPostState extends State<GuestPost> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: appBarOverall(
          heading: "Guest Posts",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(
                  isGuest: true,
                ),
              ),
            );
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore.collection("Guest-Stories").snapshots(),
            builder: (context, snapshot) {
              likedStories.clear();
              if (snapshot.hasData)
                snapshot.data.docs.forEach((result) {
                  guestStories.add(StoryData.fromSnapshot(result));
                });
              return CommonCardViewScreen(
                storyList: guestStories,
              );
            }),
      ),
    );
  }
}
