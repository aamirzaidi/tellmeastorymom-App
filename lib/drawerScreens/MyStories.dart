import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CommonCardViewScreen.dart';
import 'package:tellmeastorymom/commonWidgets/SearchScreen.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/providers/userData.dart';

class MyStories extends StatefulWidget {
  @override
  _MyStoriesState createState() => _MyStoriesState();
}

class _MyStoriesState extends State<MyStories> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBarOverall(
            heading: "My Stories",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            }),
        body: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore.collection("Stories").snapshots(),
            builder: (context, snapshot) {
              myStories.clear();
              if (snapshot.hasData){
                snapshot.data.docs.forEach((result) {
                  if(result.get("author") == UserData.getUserName()){
                    myStories.add(StoryData.fromSnapshot(result));
                  }
                });
                return CommonCardViewScreen(
                  storyList: myStories,
                );
              }else{
                return Center(child: Text('No Stories Uploaded',style: TextStyle(fontSize: 30.0,color: primaryColour),),);
              }
            }),
      ),
    );
  }
}

