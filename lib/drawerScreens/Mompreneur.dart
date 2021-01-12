import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CommonCardViewScreen.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/drawerScreens/mompreneurScreens/ListBuilder.dart';
import 'package:tellmeastorymom/providers/categoryData.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

class Mompreneur extends StatefulWidget {
  @override
  _MompreneurState createState() => _MompreneurState();
}

class _MompreneurState extends State<Mompreneur> with SingleTickerProviderStateMixin {
  TabController tabController;
  bool isLoading = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: TabBar(
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 15.0 * ScreenSize.heightMultiplyingFactor,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins-Light',
                  fontSize: 15.0 * ScreenSize.heightMultiplyingFactor,
                ),
                indicatorPadding: EdgeInsets.only(bottom: 10.0 * ScreenSize.heightMultiplyingFactor, right: 15.0 * ScreenSize.widthMultiplyingFactor),
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2.5 * ScreenSize.heightMultiplyingFactor,
                indicatorColor: Colors.white,
                tabs: [
              Tab(text: "Interviews"),
              Tab(text: "Diary"),
            ]),
          ),
          isLoading
              ? circularProgressIndicator()
              : TabBarView(
            controller: tabController,
            children: [
              // Interview(),
              ListBuilder(
                storyList: popularStories,
              ),
              // Diary(),
              ListBuilder(
                storyList: popularStories,
                isDiary: true,
              ),
            ],
          ),
        ],
      )
    );
  }
}

class NestedTabBar extends StatefulWidget {
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}
class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  TabController _nestedTabController;
  bool isLoading = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<StoryData> getMomStories(List<StoryData> stories, String filterBy){
    List<StoryData> filteredStories;
    for(StoryData story in stories){
      for(String category in story.related){
        if(category == filterBy){
          filteredStories.add(story);
        }
      }
    }
    return filteredStories;
  }

  CategoryData returnCategoryData(List<CategoryData> category,String name){
    int index = 0;
    for(int i=0;i<category.length;i++){
      if(category[i].categoryName==name){
        index = i;
      }
    }
    return category[index];
  }

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TabBar(
                physics: NeverScrollableScrollPhysics(),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 15.0 * ScreenSize.heightMultiplyingFactor,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Poppins-Light',
                  fontSize: 15.0 * ScreenSize.heightMultiplyingFactor,
                ),
                controller: _nestedTabController,
                indicatorColor: primaryColour,
                labelColor: primaryColour,
                unselectedLabelColor: Colors.black87,
                tabs: <Widget>[
                  Tab(
                    text: "Interviews",
                  ),
                  Tab(
                    text: "Diary",
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: isLoading
                      ? circularProgressIndicator()
                      : TabBarView(
                    controller: _nestedTabController,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: firebaseFirestore.collection("Stories").where('related',arrayContains: 'Interview').snapshots(),
                          builder: (context, snapshot) {
                            List<StoryData> interviewStoryList =[];
                            if (snapshot.hasData) {
                              snapshot.data.docs.forEach((result) {
                                interviewStoryList.add(StoryData.fromSnapshot(result));
                              });
                              return CommonCardViewScreen(
                                storyList: interviewStoryList,
                                boxFit: BoxFit.scaleDown,
                              );
                            }
                            return circularProgressIndicator();
                          }),
                      StreamBuilder<QuerySnapshot>(
                          stream: firebaseFirestore.collection("Stories").where('related',arrayContains: 'Diary').snapshots(),
                          builder: (context, snapshot) {
                            List<StoryData> diaryStoryList =[];
                            if (snapshot.hasData) {
                              snapshot.data.docs.forEach((result) {
                                diaryStoryList.add(StoryData.fromSnapshot(result));
                              });
                              return CommonCardViewScreen(
                                storyList: diaryStoryList,
                                boxFit: BoxFit.scaleDown,
                              );
                            }
                            return circularProgressIndicator();
                          }),
                    ],
                  ),
                ),
              )
            ],
          );
        }
  }
