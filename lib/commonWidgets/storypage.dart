import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tellmeastorymom/commonWidgets/HomeScreenCardView.dart';
import 'package:tellmeastorymom/commonWidgets/rowForViewAll.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/commentData.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/providers/userData.dart';
import 'package:tellmeastorymom/screens/AddStoryScreens/editScreen.dart';
import 'package:tellmeastorymom/screens/Home.dart';
import 'StoriesScreen.dart';
import 'commentList.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tellmeastorymom/providers/firebase_dynamic_link.dart';
import 'package:clipboard/clipboard.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class StoryPage extends StatefulWidget {
  
  final StoryData story;
  final hideSpeechButton;

  const StoryPage({Key key, this.story,this.hideSpeechButton = false}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<CommentData> commentList = [];
  List<String> recents = [];

  List<bool> isSelected;
  int fontSize = 17;

  var storyPrimaryColor = Colors.white;
  var storySecondaryColor = Colors.black;

  Future isDarkMode() async{
    await firebaseFirestore.collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid).get().then((snapshot) {
          try{
            bool isDark = snapshot.get('isDark');
            if(isDark == true){
              toggleDarkMode(false, true);
            }
          }catch(e){
            print(e);
          }
        });
  }

  void toggleDarkMode(bool value, bool firstTime) async{
    //value = true -> Dark Mode previously enabled
    
    Color tempColor = storyPrimaryColor;
    storyPrimaryColor = storySecondaryColor;
    storySecondaryColor = tempColor;

    if(firstTime == false){
      if(value == false){
        //Enable dark mode
        await firebaseFirestore.collection('Users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({'isDark': true})
            .then((value) => print("Updated"))
            .catchError((error) => print("Failed to update : $error"));

      }else{
        //Disable dark Mode
        await firebaseFirestore.collection('Users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({'isDark': true})
            .then((value) => print("Updated"))
            .catchError((error) => print("Failed to update : $error"));
      }
    }
    setState(() {});
  }

  int getFontSize(int index){
    if(index==0){
      return 14;
    }else if(index==1){
      return 17;
    }else if(index==2){
      return 20;
    }
  }
  
  Widget getStoryContent(String content){
    if(content.length == 0){
      return SizedBox(height: 0,);
    }else{
      return Padding(
        padding: EdgeInsets.only(
          left: 15 * ScreenSize.widthMultiplyingFactor,
          right: 15 * ScreenSize.widthMultiplyingFactor,
          top: 10,
          bottom: 10,
        ),
        child: Text(
          content.replaceAll(RegExp(r'\\n'), "\n"),
          style: TextStyle(
            color: storySecondaryColor,
            fontFamily: 'Poppins-Light',
            fontSize: fontSize * ScreenSize.heightMultiplyingFactor,
          ),
          textAlign: TextAlign.justify,
        ),
      );
    }
  }
  
  Widget getStoryImages(String url){
    if(url == null){
      return SizedBox(height: 0,);
    }else{
      return Padding(
        padding: const EdgeInsets.only(left : 18.0, right: 18.0, top: 10.0, bottom: 10.0),
        child: Container(
          width: double.infinity,
          height: 200 * ScreenSize.heightMultiplyingFactor,
          child: Image(
            image: NetworkImage(
              url,
            ),
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }

  void copyContent(String storyUrl, String content){
    FlutterClipboard.copy(storyUrl + "\n" + content).then(( value ) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied Content! Paste it anywhere!"))),);
  }
  
  @override
  void initState() {
    isSelected = [
      false,
      true,
      false,
    ];

    isDarkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: storyPrimaryColor,
        resizeToAvoidBottomInset: false,
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            StoryHeader(
              story: widget.story,
              color: storySecondaryColor,
              hideSpeechButton: widget.hideSpeechButton,
            ),
            Divider(
              height: 30.0 * ScreenSize.heightMultiplyingFactor,
              thickness: 1.0,
              color: Color(0xFF707070),
            ),
            Padding(
              padding: const EdgeInsets.only(left : 12.0,right : 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ToggleButtons(
                    fillColor: storyPrimaryColor,
                      color: primaryColour,
                      children: [
                        Text('A',style: TextStyle(fontSize: 12),),
                        Text('A',style: TextStyle(fontSize: 16),),
                        Text('A',style: TextStyle(fontSize: 20),),
                      ], isSelected: isSelected,
                    onPressed: (index){
                        for(var i =0; i<isSelected.length;i++){
                          if(i==index){
                            isSelected[i] = true;
                          }else{
                            isSelected[i] = false;
                          }
                        }
                        fontSize = getFontSize(index);
                        setState(() {});
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => toggleDarkMode(storyPrimaryColor != Colors.white, false),
                        child: CircleAvatar(
                          backgroundColor: storySecondaryColor,
                          child:
                          Icon(MaterialCommunityIcons.weather_night,
                          color: storyPrimaryColor,),),
                      ),
                      userAdmin == true ? Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SelectNewImage(storyId: widget.story.id,)));

                          },
                          child: CircleAvatar(
                            backgroundColor: storySecondaryColor,
                            child:
                            Icon(MaterialCommunityIcons.image_search,
                              color: storyPrimaryColor,),),
                        ),
                      ) : SizedBox(),
                      userAdmin == true ? Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: GestureDetector(
                          onTap: ()async{
                            var editStorySnapshot;
                            String contentToEdit;
                            editStorySnapshot = await FirebaseFirestore.instance.collection('Stories').doc(widget.story.id).get();
                            contentToEdit = editStorySnapshot.get('content');
                            Navigator.push(context, MaterialPageRoute(
                                builder: (content) {
                                  return EditScreen(
                                  fieldName: 'content',
                                  docID: widget.story.id,
                                  content: contentToEdit,
                                  collectionName: 'Stories',
                                );} ));
                          },
                          child: CircleAvatar(
                            backgroundColor: storySecondaryColor,
                            child:
                            Icon(MaterialCommunityIcons.file_document_edit,
                              color: storyPrimaryColor,),),
                        ),
                      ) : SizedBox(),
                      userAdmin == true ? Padding(
                         padding: const EdgeInsets.only(left: 4.0),
                         child: GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Story Delete?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Yes"),
                                      onPressed: () async{
                                        await FirebaseFirestore.instance.collection('Stories').doc(widget.story.id).delete().then((value) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(),
                                              ),
                                                  (Route<dynamic> route) => false);
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("No"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: storySecondaryColor,
                            child:
                            Icon(MaterialCommunityIcons.delete,
                              color: storyPrimaryColor,),),
                      ),
                       ) : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
            getStoryContent(widget.story.content),
            getStoryImages(widget.story.storyImageURL2),
            getStoryContent(widget.story.content2),
            getStoryImages(widget.story.storyImageURL3),
            getStoryContent(widget.story.content3),
            getStoryImages(widget.story.storyImageURL4),
            getStoryContent(widget.story.content4),
            getStoryImages(widget.story.storyImageURL5),
            getStoryContent(widget.story.content5),
            getStoryImages(widget.story.storyImageURL6),
            getStoryContent(widget.story.content6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.0 * ScreenSize.widthMultiplyingFactor,
                  padding: EdgeInsets.fromLTRB(
                    10 * ScreenSize.widthMultiplyingFactor,
                    10 * ScreenSize.heightMultiplyingFactor,
                    10 * ScreenSize.widthMultiplyingFactor,
                    10 * ScreenSize.heightMultiplyingFactor,
                  ),
                  margin: EdgeInsets.only(
                      left: 15.0 * ScreenSize.widthMultiplyingFactor),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 6.0,
                        color: Colors.black54,
                        offset: Offset(0, 3),
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Like story: ",
                        style: TextStyle(
                          fontFamily: 'Poppins-Regular',
                          fontSize: 12 * ScreenSize.heightMultiplyingFactor,
                        ),
                      ),
                      SizedBox(
                        width: 15.0 * ScreenSize.widthMultiplyingFactor,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: firebaseFirestore
                            .collection("Stories")
                            .doc(widget.story.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<String> isLiked = [];
                          if (snapshot.hasData) {
                            try{
                              isLiked = snapshot.data.get("isLiked") == null
                                  ? []
                                  : snapshot.data
                                  .get("isLiked")
                                  .cast<String>();
                            }catch(e){
                              isLiked = [];
                            }
                          }
                          print(isLiked.length);
                          return GestureDetector(
                            onTap: () {
                              bool valueOfList =
                                  isLiked.contains(UserData.getUserId());
                              if (valueOfList) {
                                firebaseFirestore
                                    .collection("Stories")
                                    .doc(widget.story.id)
                                    .update({
                                  "isLiked": FieldValue.arrayRemove(
                                      [UserData.getUserId()])
                                });
                              } else {
                                firebaseFirestore
                                    .collection("Stories")
                                    .doc(widget.story.id)
                                    .update({
                                  "isLiked": FieldValue.arrayUnion(
                                      [UserData.getUserId()])
                                });
                              }
                            },
                            child: Icon(
                              isLiked.contains(UserData.getUserId())
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 24 * ScreenSize.heightMultiplyingFactor,
                              color: isLiked.contains(UserData.getUserId())
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right : 10.0),
                  child: IconButton(
                    icon : Icon(Icons.copy_outlined),
                    color: Colors.blue,
                    iconSize: 25 * ScreenSize.widthMultiplyingFactor,
                    onPressed: () async{
                      String generatedDeepLink = await FirebaseDynamicLinkService.createDynamicLink(false, widget.story);
                      final storyContent = widget.story.content.substring(0,300).replaceAll(RegExp(r'\\n'), "\n") + ". . ." + "\n\nRead complete story from the link";

                      copyContent(generatedDeepLink, storyContent);
                    }
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0,),
            Divider(
              thickness: 1.0,
              color: Color(0xFF707070),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 8.0,),
                  UserReview(
                    storyId: widget.story.id,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: RowViewAll(
                      heading: "Recently Viewed Stories",
                      onpressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StoriesScreen(
                              heading: "Recently Viewed Stories",
                              itemCount: recentlyViewedStories.length,
                              storyList: recentlyViewedStories,
                            ),
                          ),
                        );
                        // print("Pressed Recently Viewed Stories View All");
                      },
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: firebaseFirestore
                        .collection("Users")
                        .doc(UserData.getUserId())
                        .snapshots(),
                    builder: (context, snapshot) {
                      recents.clear();
                      if (snapshot.hasData) {
                        recents = snapshot.data.get("recents")== null
                            ? []
                            : snapshot.data.get("recents").cast<String>();
                        return StreamBuilder<QuerySnapshot>(
                          stream: firebaseFirestore.collection("Stories").snapshots(),
                          builder: (context, snapshot) {
                            recentlyViewedStories.clear();
                            if (snapshot.hasData) {
                              for (var i = 0; i < recents.length; i++) {
                                snapshot.data.docs.forEach((result) {
                                  if (recents[i] == result.id) {
                                    recentlyViewedStories
                                        .add(StoryData.fromSnapshot(result));
                                  }
                                });
                              }

                              return HomeScreenCardView(
                                boxHeight: 210 * ScreenSize.heightMultiplyingFactor,
                                insideHeight:
                                141 * ScreenSize.heightMultiplyingFactor,
                                insideWidth: 220 * ScreenSize.widthMultiplyingFactor,
                                storyList: recentlyViewedStories,
                                itemCard: true,
                              );
                            }
                            return circularProgressIndicator();
                          },
                        );
                      }
                      return circularProgressIndicator();
                    },
                  ),
                  Divider(
                    height: 50.0 * ScreenSize.heightMultiplyingFactor,
                    thickness: 1.0,
                    color: Color(0xFF707070),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0 * ScreenSize.widthMultiplyingFactor,
                    ),
                    child: Text(
                      'Reader\'s Reviews',
                      style: TextStyle(
                        fontFamily: 'Poppins-Medium',
                        fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: firebaseFirestore
                        .collection('Stories')
                        .doc(widget.story.id)
                        .collection('Comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      commentList.clear();
                      if (snapshot.hasData) {
                        snapshot.data.docs.forEach((result) {
                          commentList.add(
                            CommentData(
                                storyId: widget.story.id,
                                ratingStars: double.parse(result.get('ratingStars').toString()),
                                id: result.id.toString(),
                                postedOn : result.get('postedOn'),
                                commentBy: result.get('commentBy'),
                                content: result.get('content'),
                            ),
                          );
                        });
                      }
                      return CommentList(
                        hasRating: true,
                        commentList: commentList,
                      );
                    },
                  ),
                  SizedBox(
                    height: 15.0 * ScreenSize.heightMultiplyingFactor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryHeader extends StatefulWidget {
  final StoryData story;
  final color;
  final hideSpeechButton;

  const StoryHeader({Key key, this.story,this.color,this.hideSpeechButton = false}) : super(key: key);
  @override
  _StoryHeaderState createState() => _StoryHeaderState();
}

class _StoryHeaderState extends State<StoryHeader> {
  final FlutterTts flutterTts = FlutterTts();

  List<Color> colorList = [
    Color(0xFF5A8FD8),
    Color(0xFFFF5954),
    Color(0xFFFF9870),
    Color(0xFF6D60F8)
  ];
  String userID = "";

  @override
  void initState() {
    super.initState();
    userID = UserData.getUserId();

  }

  @override
  Widget build(BuildContext context) {

    speak() async {
      print(widget.story.content);
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.4);
      await flutterTts.setSpeechRate(0.35);
      await flutterTts.speak(
          widget.story.content.replaceAll(RegExp(r'\\n'), "\n"));
    }

    double overallRating = 0;
    int commentCount = 0;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        await flutterTts.stop();
        Navigator.of(context).pop();
      },

      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 250.0 * ScreenSize.heightMultiplyingFactor,
                  width: 450.0 * ScreenSize.widthMultiplyingFactor,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: Offset(0, 3),
                        color: Colors.black54,
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.story.storyImageURL,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await flutterTts.stop();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  3.0 * ScreenSize.widthMultiplyingFactor,
                              vertical:
                                  3.0 * ScreenSize.heightMultiplyingFactor),
                          child: Icon(
                            Icons.arrow_back,
                            size: 35 * ScreenSize.heightMultiplyingFactor,
                          ),
                        ),
                      ),
                      Spacer(),
                      widget.hideSpeechButton == false ? GestureDetector(
                        onTap: () async{
                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: primaryColour,
                            content: Text('Double tap the icon again to stop Computer Voice!',
                            style: TextStyle(color: Colors.white,
                            ),),
                          ));
                          await speak();
                        },
                        onDoubleTap: () async {
                          await flutterTts.stop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  3.0 * ScreenSize.widthMultiplyingFactor,
                              vertical:
                                  3.0 * ScreenSize.heightMultiplyingFactor),
                          child: Icon(
                            Icons.volume_up,
                            size: 35 * ScreenSize.heightMultiplyingFactor,
                            color: Colors.black,
                          ),
                        ),
                      ) : SizedBox(),
                      SizedBox(
                        width: 20.0 * ScreenSize.widthMultiplyingFactor,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: firebaseFirestore
                            .collection("Stories")
                            .doc(widget.story.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<String> isBookmarked = [];
                          if (snapshot.hasData) {
                            try{
                              isBookmarked =
                              snapshot.data.get("isBookmarked") == null
                                  ? []
                                  : snapshot.data
                                  .get("isBookmarked")
                                  .cast<String>();
                            }catch(e){
                              isBookmarked = [];
                            }

                          }

                          return GestureDetector(
                            onTap: () {
                              bool valueOfList = isBookmarked.contains(userID);
                              if (valueOfList) {
                                firebaseFirestore
                                    .collection("Stories")
                                    .doc(widget.story.id)
                                    .update({
                                  "isBookmarked":
                                      FieldValue.arrayRemove([userID])
                                });
                              } else {
                                firebaseFirestore
                                    .collection("Stories")
                                    .doc(widget.story.id)
                                    .update({
                                  "isBookmarked":
                                      FieldValue.arrayUnion([userID])
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      3.0 * ScreenSize.widthMultiplyingFactor,
                                  vertical:
                                      3.0 * ScreenSize.heightMultiplyingFactor),
                              child: Icon(
                                isBookmarked.contains(userID)
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: isBookmarked.contains(userID)
                                    ? primaryColour
                                    : Colors.black,
                                size: 35 * ScreenSize.heightMultiplyingFactor,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15.0 * ScreenSize.heightMultiplyingFactor,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 15 * ScreenSize.heightMultiplyingFactor,
                right: 15 * ScreenSize.heightMultiplyingFactor,
              ),
              child: Row(
                children: [
                  Container(
                    width: 300 * ScreenSize.widthMultiplyingFactor,
                    child: Text(
                      widget.story.title,
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
                        color: widget.color,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      String generatedDeepLink = await FirebaseDynamicLinkService.createDynamicLink(false, widget.story);
                      final urlImage = '${widget.story.storyImageURL}';
                      final url =  Uri.parse(urlImage);
                      final response = await http.get(url);
                      final bytes = response.bodyBytes;

                      final temp = await getTemporaryDirectory();
                      final path = '${temp.path}/image.jpg';
                      File(path).writeAsBytesSync(bytes);

                      Share.shareFiles(
                        [path],
                         subject: '${widget.story.title}',
                         text: "${widget.story.title}\n${widget.story.content.substring(0,100).replaceAll(RegExp(r'\\n'), "\n")}...\n\n$generatedDeepLink\nCheckout this amazing story on app and listen via reader !"
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.0 * ScreenSize.widthMultiplyingFactor,
                          vertical: 5.0 * ScreenSize.heightMultiplyingFactor),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FontAwesome.share,
                        size: 30 * ScreenSize.heightMultiplyingFactor,
                        color:Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15 * ScreenSize.heightMultiplyingFactor),
              child: Text(
                widget.story.author,
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
                  color: widget.color,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15 * ScreenSize.heightMultiplyingFactor),
              child: Text(
                widget.story.posted,
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
                  color: widget.color,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0 * ScreenSize.widthMultiplyingFactor,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore
                    .collection('Stories')
                    .doc(widget.story.id)
                    .collection('Comments')
                    .snapshots(),
                builder: (context, snapshot) {
                  overallRating = 0;
                  commentCount = 0;
                  if (snapshot.hasData) {
                    snapshot.data.docs.forEach((result) {
                      commentCount++;
                      overallRating +=
                          double.parse(result.get('ratingStars').toString());
                      print(result);
                    });
                    overallRating /= commentCount;
                  }
                  // print(commentList[0]);
                  return commentCount == 0
                      ? SizedBox()
                      : Row(
                          children: [
                            RatingBarIndicator(
                              rating: overallRating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize:
                                  25.0 * ScreenSize.heightMultiplyingFactor,
                            ),
                            Text(
                              "   " + overallRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize:
                                    14.0 * ScreenSize.heightMultiplyingFactor,
                                color: widget.color,
                              ),
                            ),
                            Text(
                              "   (" + commentCount.toString() + " ratings)",
                              style: TextStyle(
                                fontFamily: 'Poppins-Regular',
                                fontSize:
                                    14.0 * ScreenSize.heightMultiplyingFactor,
                                color: widget.color.withOpacity(0.5),
                              ),
                            ),
                          ],
                        );
                  // }
                  // return circularProgressIndicator();
                },
              ),
            ),
            SizedBox(
              height: 8.0 * ScreenSize.heightMultiplyingFactor,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 15 * ScreenSize.heightMultiplyingFactor),
              child: Wrap(
                spacing: 5.0 * ScreenSize.widthMultiplyingFactor,
                runSpacing: 5.0,
                // runSpacing: 7.0,
                children: List<Widget>.generate(
                  widget.story.related.length,
                  (int i) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 25.0 * ScreenSize.heightMultiplyingFactor,
                          padding: EdgeInsets.fromLTRB(
                            10.0 * ScreenSize.widthMultiplyingFactor,
                            5.0 * ScreenSize.heightMultiplyingFactor,
                            10.0 * ScreenSize.widthMultiplyingFactor,
                            5.0 * ScreenSize.heightMultiplyingFactor,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: colorList[i % colorList.length],
                          ),
                          child: Text(
                            widget.story.related[i],
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize:
                                  12.0 * ScreenSize.heightMultiplyingFactor,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserReview extends StatefulWidget {
  final String storyId;

  const UserReview({Key key, this.storyId}) : super(key: key);

  @override
  _UserReviewState createState() => _UserReviewState();
}

class _UserReviewState extends State<UserReview> {
  double ratingStar = 3.0;
  String comment = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0 * ScreenSize.widthMultiplyingFactor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Rate story : ',
                style: TextStyle(
                  fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
                  fontFamily: 'Poppins-Medium',
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0 * ScreenSize.widthMultiplyingFactor,
                ),
                height: 45.0 * ScreenSize.heightMultiplyingFactor,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
                child: Center(
                  child: RatingBar(
                    initialRating: 3,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30.0 * ScreenSize.heightMultiplyingFactor,
                    itemPadding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
                    ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      empty: Icon(
                        Icons.star_border,
                        color: Colors.black87,
                      ),
                      half: Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        ratingStar = rating;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 33.0 * ScreenSize.heightMultiplyingFactor,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Please share views to inspire others :',
              style: TextStyle(
                fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
                fontFamily: 'Poppins-Medium',
              ),
            ),
          ),
          Form(
            key: _formKey,
            //TODO: _autoValidate removed
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 15.0 * ScreenSize.widthMultiplyingFactor,
              ),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    comment = value;
                  });
                },
                validator: (value) {
                  if (value.length < 4)
                    return "Minimum 4 characters required";
                  return null;
                },
                controller: textEditingController,
                decoration: InputDecoration(
                  focusColor: Colors.black45,
                  hintText: 'Enter your comment here..',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                maxLength: 245,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              color: Colors.white,
              elevation: 5.0 * ScreenSize.heightMultiplyingFactor,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  CommentData commentData = CommentData(
                      commentBy: UserData.getUserName(),
                      content: comment.trim(),
                      ratingStars: ratingStar,
                      postedOn: DateFormat("dd-MM-yy").format(DateTime.now()));
                  //good story aa to gaya neeche
                  firebaseFirestore
                      .collection('Stories')
                      .doc(widget.storyId)
                      .collection('Comments')
                      .add(commentData.toJson());

                  setState(() {
                    textEditingController.clear();
                    _autoValidate = false;
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Comment Posted')));
                } else {
                  setState(() {
                    _autoValidate = true;
                  });
                }
              },
              child: Text(
                'Post Comment',
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12.0 * ScreenSize.heightMultiplyingFactor,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectNewImage extends StatefulWidget {
  final storyId;
  SelectNewImage({@required this.storyId});
  
  @override
  _SelectNewImageState createState() => _SelectNewImageState();
}

class _SelectNewImageState extends State<SelectNewImage> {

  File image;
  String uploadedFileURL;
  final picker = ImagePicker();

  void _startPickingImage(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: ctx,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                  dense: true,
                  trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          image = null;
                        });
                        Navigator.of(ctx).pop();
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.black45,
                      )),
                  title: Text(
                    'Choose An Option',
                    style: TextStyle(
                        fontFamily: "Gilroy",
                        color: Colors.black45,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            //SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Colors.redAccent,
                      ),
                      onPressed: pickImageFromCamera,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        size: 30,
                        color: Colors.redAccent,
                      ),
                      onPressed: pickImageFromGallary,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Future pickImageFromGallary() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }

  Future pickImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
  }

  Future<String> uploadFile(File img) async {
    var path = img.path;
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('storyThumbnail/${path.split("/").last}}}');
    UploadTask uploadTask = storageReference.putFile(img);
    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      uploadedFileURL = await storageReference.getDownloadURL();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColour,
        centerTitle: true,
        title: Text("Select New Image"),
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            SizedBox(height: 60.0,),
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: image == null ? primaryColour : Colors.white,
              ),
              child: TextFormField(
                enabled: false,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: image == null
                          ? Colors.white
                          : Colors.red),
                  hintText: image == null
                      ? "Select Image"
                      : "Image Selected",
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                _startPickingImage(context);
              },
              child: Container(
                color: Colors.grey[400],
                child: image == null
                    ? Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          size: 100,
                          color: Colors.white,
                        ),
                        Text(
                          'Add Image',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Gilroy",
                              fontWeight: FontWeight.w600),
                        )
                        //SizedBox(height:height*0.06),
                      ]),
                )
                    : Image(
                    height: 200,
                    width: MediaQuery.of(context).size.width - 60,
                    fit: BoxFit.cover,
                    image: FileImage(image)),
              ),
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: ()async{
                if(image==null){

                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("No Image Selected"),backgroundColor: primaryColour,),
                  );
                }else{
                  await uploadFile(image);
                  await FirebaseFirestore.instance.collection("Stories").doc(widget.storyId).update({'storyImageURL' : '$uploadedFileURL'})
                      .then((value){
                    Navigator.pop(context);

                  });
                }
              },
              child: Text('Upload Image'),
            )
          ],
        ),
      ));
  }
}
