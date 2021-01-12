import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

import '../constants/screenSize.dart';
import 'CommonCardViewScreen.dart';

class SearchScreen extends StatefulWidget {
  final bool isGuest;

  const SearchScreen({Key key, this.isGuest = false}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchData = TextEditingController();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController textEditingController = TextEditingController();
  List<StoryData> allStories = [];
  String textSearch = 'some loreal epsum';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: primaryColour,
          automaticallyImplyLeading: false,
          title: Container(
            height: 50 * ScreenSize.heightMultiplyingFactor,
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.white,
            ),
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    textEditingController.clear();
                    // Navigator.of(context).pop();
                  },
                ),
                hintText: "Search a story ...",
              ),
              // keyboardType: TextInputType.name,
              onChanged: (value) {
                setState(() {
                  if (value == "") {
                    textSearch = "99";
                  } else {
                    textSearch = value;
                  }
                });
                print(value);
              },
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: widget.isGuest
              ? firebaseFirestore.collection("Guest-Stories").snapshots()
              : firebaseFirestore.collection("Stories").snapshots(),
          builder: (context, snapshot) {
            allStories.clear();
            if (snapshot.hasData)
              snapshot.data.docs.forEach((result) {
                print(result.data());
                if (StoryData.fromSnapshot(result)
                    .title
                    .toLowerCase()
                    .contains(textSearch.toLowerCase())) {
                  allStories.add(StoryData.fromSnapshot(result));
                }else if (StoryData.fromSnapshot(result)
                    .content
                    .toLowerCase()
                    .contains(textSearch.toLowerCase())) {
                  allStories.add(StoryData.fromSnapshot(result));
                }
              });
            print(allStories.toString());

            return allStories.isEmpty
                ? Center(
                    child: Column(
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
                            "No Stories to display!!",
                            style: TextStyle(
                              fontSize:
                                  18.0 * ScreenSize.heightMultiplyingFactor,
                              fontFamily: 'Poppins-SemiBold',
                              color: primaryColour,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : CommonCardViewScreen(
                    storyList: allStories,
                  );
          },
        ),
      ),
    );
  }
}
