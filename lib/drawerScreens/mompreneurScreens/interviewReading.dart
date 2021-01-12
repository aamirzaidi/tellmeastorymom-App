import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share/share.dart';
import 'package:tellmeastorymom/commonWidgets/commentList.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/providers/commentData.dart';
import 'package:tellmeastorymom/providers/userData.dart';
import 'package:intl/intl.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class InterviewReading extends StatefulWidget {
  final StoryData story;
  final bool isDiary;
  InterviewReading({
    this.story,
    this.isDiary = false,
  });

  @override
  _InterviewReadingState createState() => _InterviewReadingState();
}

class _InterviewReadingState extends State<InterviewReading> {

  List<CommentData> commentList = [];
  List<bool> isSelected;
  int fontSize = 17;

  int getFontSize(int index){
    if(index==0){
      return 14;
    }else if(index==1){
      return 17;
    }else if(index==2){
      return 20;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    isSelected = [
      false,
      true,
      false,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            InterviewStoryHeader(widget.story),
            Divider(
              height: 30.0 * ScreenSize.heightMultiplyingFactor,
              thickness: 1.0,
              color: Color(0xFF707070),
            ),
            Padding(
              padding: const EdgeInsets.only(left : 12.0),
              child: ToggleButtons(
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
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 15 * ScreenSize.widthMultiplyingFactor,
                right: 15 * ScreenSize.widthMultiplyingFactor,
                bottom: 15 * ScreenSize.heightMultiplyingFactor,
              ),
              child: Text(
                widget.story.content.replaceAll(RegExp(r'\\n'), "\n"),
                style: TextStyle(
                  fontFamily: 'Poppins-Light',
                  fontSize: fontSize * ScreenSize.heightMultiplyingFactor,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Divider(
              height: 30.0 * ScreenSize.heightMultiplyingFactor,
              thickness: 1.0,
              color: Color(0xFF707070),
            ),
            !widget.isDiary
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0 * ScreenSize.widthMultiplyingFactor,
                          vertical: 15.0 * ScreenSize.heightMultiplyingFactor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize:
                                    14.0 * ScreenSize.heightMultiplyingFactor,
                                fontFamily: 'Poppins-SemiBold',
                              ),
                            ),
                            Text(
                              widget.story.content
                                  .replaceAll(RegExp(r'\\n'), "\n"),
                              style: TextStyle(
                                fontSize:
                                    15.0 * ScreenSize.heightMultiplyingFactor,
                                fontFamily: 'Poppins-Light',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 30.0 * ScreenSize.heightMultiplyingFactor,
                        thickness: 1.0,
                        color: Color(0xFF707070),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0 * ScreenSize.widthMultiplyingFactor,
                          vertical: 15.0 * ScreenSize.heightMultiplyingFactor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interview',
                              style: TextStyle(
                                fontSize:
                                    14.0 * ScreenSize.heightMultiplyingFactor,
                                fontFamily: 'Poppins-SemiBold',
                              ),
                            ),
                            QnAList(),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Container(
            //       width: 145.0 * ScreenSize.widthMultiplyingFactor,
            //       padding: EdgeInsets.fromLTRB(
            //         10 * ScreenSize.widthMultiplyingFactor,
            //         10 * ScreenSize.heightMultiplyingFactor,
            //         10 * ScreenSize.widthMultiplyingFactor,
            //         10 * ScreenSize.heightMultiplyingFactor,
            //       ),
            //       margin: EdgeInsets.only(left: 15.0 * ScreenSize.widthMultiplyingFactor),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(30.0),
            //         boxShadow: <BoxShadow>[
            //           BoxShadow(
            //             blurRadius: 6.0,
            //             color: Colors.black.withOpacity(0.16),
            //             offset: Offset(0, 3),
            //           )
            //         ],
            //         color: Colors.white,
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             !widget.isDiary ? "Like Interview: " : "Like Diary: ",
            //             style: TextStyle(
            //               fontFamily: 'Poppins-Regular',
            //               fontSize: 12 * ScreenSize.heightMultiplyingFactor,
            //             ),
            //           ),
            //           SizedBox(
            //             width: 15.0 * ScreenSize.widthMultiplyingFactor,
            //           ),
            //           StreamBuilder<DocumentSnapshot>(
            //               stream: firebaseFirestore.collection("Stories").doc(widget.story.id).snapshots(),
            //               builder: (context, snapshot) {
            //                 List<String> isLiked = [];
            //                 if (snapshot.hasData) {
            //                   isLiked = snapshot.data.data()["isLiked"] == null ? [] : snapshot.data.data()["isLiked"].cast<String>();
            //                 }
            //                 print(isLiked.length);
            //                 return GestureDetector(
            //                   onTap: () {
            //                     bool valueOfList = isLiked.contains(UserData.getUserId());
            //                     if (valueOfList) {
            //                       firebaseFirestore.collection("Stories").doc(widget.story.id).update({
            //                         "isLiked": FieldValue.arrayRemove([UserData.getUserId()])
            //                       });
            //                     } else {
            //                       firebaseFirestore.collection("Stories").doc(widget.story.id).update({
            //                         "isLiked": FieldValue.arrayUnion([UserData.getUserId()])
            //                       });
            //                     }
            //                   },
            //                   child: Icon(
            //                     isLiked.contains(UserData.getUserId()) ? Icons.favorite : Icons.favorite_border,
            //                     size: 24 * ScreenSize.heightMultiplyingFactor,
            //                     color: isLiked.contains(UserData.getUserId()) ? Colors.red : Colors.black,
            //                   ),
            //                 );
            //               }),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // Divider(
            //   height: 50.0 * ScreenSize.heightMultiplyingFactor,
            //   thickness: 1.0,
            //   color: Color(0xFF707070),
            // ),
            // RowViewAll(
            //   heading: "Recently Viewed",
            //   onpressed: () {},
            // ),
            // HomeScreenCardView(
            //   boxHeight: 210.0 * ScreenSize.heightMultiplyingFactor,
            //   insideWidth: 220.0 * ScreenSize.widthMultiplyingFactor,
            //   insideHeight: 141.0 * ScreenSize.heightMultiplyingFactor,
            //   storyList: popularStories,
            //   isInterview: true,
            //   //TODO:CHANGE THE STORY LIST
            // ),
            // Divider(
            //   height: 50.0 * ScreenSize.heightMultiplyingFactor,
            //   thickness: 1.0,
            //   color: Color(0xFF707070),
            // ),
            UserReview(
              storyId: widget.story.id,
            ),
            Divider(
              height: 30.0 * ScreenSize.heightMultiplyingFactor,
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
                      commentList.add(CommentData.fromSnapshot(result));
                      print(result);
                    });
                  }
                  // print(commentList[0]);
                  return CommentList(
                    hasRating: true,
                    commentList: commentList,
                  );
                }),
            SizedBox(
              height: 15.0 * ScreenSize.heightMultiplyingFactor,
            ),
          ],
        ),
      ),
    );
  }
}

class InterviewStoryHeader extends StatefulWidget {
  final StoryData story;
  InterviewStoryHeader(this.story);
  @override
  _InterviewStoryHeaderState createState() => _InterviewStoryHeaderState();
}

class _InterviewStoryHeaderState extends State<InterviewStoryHeader> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Container(
//      margin: EdgeInsets.only(right: 0.0, left: 0.0),
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
                      color: Colors.black.withOpacity(0.16),
                    ),
                  ],
                  image: DecorationImage(
                    // image: AssetImage(
                    //   'assets/images/cardImage.jpg',
                    // ),
                    image: AdvancedNetworkImage(
                      widget.story.storyImageURL,
                      useDiskCache: true,
                      cacheRule: CacheRule(maxAge: const Duration(days: 2)),
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
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.0 * ScreenSize.widthMultiplyingFactor,
                            vertical: 3.0 * ScreenSize.heightMultiplyingFactor),
                        child: Icon(
                          // focusColor: Colors.white.withOpacity(0.8),
                          Icons.arrow_back,
                          size: 24 * ScreenSize.heightMultiplyingFactor,
                        ),
                      ),
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
                      color: Colors.black,
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Share.share(
                        '${widget.story.title}\n${widget.story.content.replaceAll(RegExp(r'\\n'), "\n")}\nCheckout this amazing story on app n listen via reader ! \n https://play.google.com/store/apps/details?id=com.tellmeastorymom.tellmeastorymom');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.0 * ScreenSize.widthMultiplyingFactor,
                        vertical: 5.0 * ScreenSize.heightMultiplyingFactor),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.share,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 15 * ScreenSize.heightMultiplyingFactor),
            child: Text(
              widget.story.author,
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 15 * ScreenSize.heightMultiplyingFactor),
            child: Text(
              widget.story.posted,
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 15 * ScreenSize.heightMultiplyingFactor),
            child: Text(
              'Estimated time to complete: ' + widget.story.estimated,
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
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
  bool _autoValidate = false;
  double ratingStar = 3.0;
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String comment = '';

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
                        Icons.star,
                        color: Colors.amber,
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
          SizedBox(
            height: 10.0 * ScreenSize.heightMultiplyingFactor,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Please share views :',
              style: TextStyle(
                fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
                fontFamily: 'Poppins-Medium',
              ),
            ),
          ),
          Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 15.0 * ScreenSize.widthMultiplyingFactor,
              ),
              // height: 143.0 * ScreenSize.heightMultiplyingFactor,
              // decoration: BoxDecoration(
              //   shape: BoxShape.rectangle,
              //   border: Border.all(
              //     color: Colors.blue,
              //     width: 1.0,
              //   ),
              // ),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    comment = value;
                  });
                },
                validator: (value) {
                  if (value.length < 80)
                    return "Minimum 80 characters required";
                  return null;
                },
                controller: textEditingController,
                decoration: InputDecoration(
                  focusColor: Colors.black.withOpacity(0.3),
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
                print('Post Comment Pressed');
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

class QnAList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return qnA();
      },
      itemCount: 5,
    );
  }
}

Widget qnA({
  String question = 'Some Question',
  String userName = 'Some User',
  String answer =
      'Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer Some Long Answer ',
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          20.0 * ScreenSize.heightMultiplyingFactor,
          0,
          3.0 * ScreenSize.heightMultiplyingFactor,
        ),
        child: Text(
          question,
          style: TextStyle(
            fontFamily: 'Poppins-Medium',
            fontSize: 12 * ScreenSize.heightMultiplyingFactor,
          ),
        ),
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: userName,
              style: TextStyle(
                fontSize: 12 * ScreenSize.heightMultiplyingFactor,
                fontFamily: 'Poppins-Medium',
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: ' : ' + answer + '\n',
              style: TextStyle(
                fontSize: 12 * ScreenSize.heightMultiplyingFactor,
                fontFamily: 'Poppins-Light',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      Divider(
        height: 20.0 * ScreenSize.heightMultiplyingFactor,
        indent: 0,
        endIndent: 0,
        thickness: 0.5,
        color: Color(0xFF707070),
      ),
    ],
  );
}
