import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CommonCardViewScreen.dart';
import 'package:tellmeastorymom/commonWidgets/SearchScreen.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/categoryData.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

class CategoryStoryList extends StatefulWidget {
  final String heading;
  final CategoryData category;

  const CategoryStoryList({Key key, this.heading, this.category})
      : super(key: key);
  @override
  _CategoryStoryListState createState() => _CategoryStoryListState();
}

class _CategoryStoryListState extends State<CategoryStoryList> {
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
            heading: widget.heading,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            }),
        body: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore.collection("Stories").snapshots(),
            builder: (context, snapshot) {
              List<StoryData> categoryStoryList = [];
              if (snapshot.hasData) {
                for (var i = 0;
                    i < widget.category.categoryStories.length;
                    i++) {
                  snapshot.data.docs.forEach((result) {
                    if (widget.category.categoryStories[i] == result.id)
                      categoryStoryList.add(StoryData.fromSnapshot(result));
                  });
                }
                return CommonCardViewScreen(
                  storyList: categoryStoryList,
                );
              }
              return circularProgressIndicator();
            }),
      ),
    );
  }
}
