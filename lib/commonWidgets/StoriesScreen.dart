import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

import 'CommonCardViewScreen.dart';
import 'SearchScreen.dart';

class StoriesScreen extends StatefulWidget {
  final String heading;
  final int itemCount;
  final List<StoryData> storyList;

  const StoriesScreen(
      {Key key, this.heading, this.storyList, this.itemCount = 0})
      : super(key: key);
  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: appBarOverall(
            heading: widget.heading,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            }),
        body: CommonCardViewScreen(
          storyList: widget.storyList,
        ),
      ),
    );
  }
}
