import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tellmeastorymom/commonWidgets/SearchScreen.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/drawerScreens/Mompreneur.dart';
import 'package:tellmeastorymom/providers/userData.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/screens/AddStoryScreens/textScreen.dart';
import 'package:tellmeastorymom/screens/homeScreens/Categories.dart';
import 'package:tellmeastorymom/screens/homeScreens/HomeDrawer.dart';
import 'package:tellmeastorymom/screens/homeScreens/Stories.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences preferences;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool userAdmin = false;
  TabController tabController;
  bool isLoading = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future getColor()async{
    preferences = await SharedPreferences.getInstance();
    int idx = preferences.getInt('color');
    primaryColour = getColorIndex(idx);
    print('Color taken from saved instance');
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        if (value != null) {
          UserData(
            FirebaseAuth.instance.currentUser.uid,
            value.data()['displayName'],
            value.data()['email'],
            value.data()['phoneNumber'],
          );
        }
      });
      var firebaseUser = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser.uid).get();
      try{
        if(firebaseUser['role'] == 'admin'){
          setState(() {
            userAdmin = true;
            print('User is Admin');
          });
        }
      }catch(e){
        print('User Not Admin');
        userAdmin = false;
      }
      setState(() {
        isLoading = false;
      });
    });
    getColor();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: primaryColour,
          title: Text(
            "Tellmeastorymom",
            style: TextStyle(
              fontFamily: 'Poppins-SemiBold',
              fontSize: 19.5 * ScreenSize.widthMultiplyingFactor,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
            ),
          ),
          bottom: TabBar(
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.5 * ScreenSize.heightMultiplyingFactor,
            indicatorColor: Colors.white,
            labelStyle: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 15.0 * ScreenSize.heightMultiplyingFactor,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Poppins-Light',
              fontSize: 15.0 * ScreenSize.heightMultiplyingFactor,
            ),
            indicatorPadding: EdgeInsets.only(
                bottom: 10.0 * ScreenSize.heightMultiplyingFactor,
                right: 15.0 * ScreenSize.widthMultiplyingFactor),
            tabs: [
              Tab(text: "Stories"),
              Tab(text: "Categories"),
              Tab(text: "Mompreneur"),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                AntDesign.staro,
                color: Colors.white,
              ),
              iconSize: 30 * ScreenSize.heightMultiplyingFactor,
              onPressed: () {
                launch(
                    "https://play.google.com/store/apps/details?id=com.tellmeastorymom.tellmeastorymom");
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesome.search,
                color: Colors.white,
              ),
              iconSize: 28 * ScreenSize.heightMultiplyingFactor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
          ],
        ),
        drawer: isLoading
            ? circularProgressIndicator()
            :HomeDrawer(admin: userAdmin,),
        body: isLoading
            ? circularProgressIndicator()
            : TabBarView(
                controller: tabController,
                children: [
                  Stories(),
                  Categories(),
                  NestedTabBar(),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TextScreen(),),),
          backgroundColor: primaryColour,
          icon: Icon(Icons.add),
          label: Text("Add Story"),
        ),
      ),
    );
  }
}
