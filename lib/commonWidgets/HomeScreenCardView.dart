import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/providers/userData.dart';
import 'storypage.dart';

class HomeScreenCardView extends StatefulWidget {
  final double boxHeight;
  final double insideHeight;
  final double insideWidth;
  final bool itemCard;
  final bool isInterview;
  final bool isDiary;
  const HomeScreenCardView({Key key, this.boxHeight, this.isInterview = false, this.isDiary = false, this.insideHeight, this.storyList, this.insideWidth, this.itemCard = false}) : super(key: key);

  final List<StoryData> storyList;

  @override
  _HomeScreenCardViewState createState() => _HomeScreenCardViewState();
}

class _HomeScreenCardViewState extends State<HomeScreenCardView> {
  List<Color> colorList = [Color(0xFF5A8FD8), Color(0xFFFF5954), Color(0xFFFF9870), Color(0xFF6D60F8)];


  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: size.width,
      height: widget.boxHeight,
      child: widget.storyList.length == 0
          ? Center(
              child: Text(
                "No Stories to display!",
                style: TextStyle(
                  color: primaryColour,
                  fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
                ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: physicsForApp,
              itemCount: widget.storyList.length < 3 ? widget.storyList.length : 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!widget.isInterview) {
                      if (recentlyViewedStories.indexWhere((element) => element.id == widget.storyList[index].id) == -1 && recentlyViewedStories.length < 7) {
                        firebaseFirestore.collection("Users").doc(UserData.getUserId()).update({
                          "recents": FieldValue.arrayUnion([widget.storyList[index].id])
                        });
                      } else if (recentlyViewedStories.indexWhere((element) => element.id == widget.storyList[index].id) == -1 && recentlyViewedStories.length >= 7) {
                        firebaseFirestore.collection("Users").doc(UserData.getUserId()).update({
                          "recents": FieldValue.arrayRemove([recentlyViewedStories.elementAt(0).id])
                        });
                        firebaseFirestore.collection("Users").doc(UserData.getUserId()).update({
                          "recents": FieldValue.arrayUnion([widget.storyList[index].id])
                        });
                      }
                      // setState(() {});
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          StoryPage(
                              story: widget.storyList[index],
                            )
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 15.0 * ScreenSize.widthMultiplyingFactor, left: index == 0 ? 15.0 * ScreenSize.widthMultiplyingFactor : 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: widget.insideHeight,
                              width: widget.insideWidth,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(25.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    blurRadius: 6.0,
                                    offset: Offset(0, 3),
                                    color: Colors.black54,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(
                                    widget.storyList[index].storyImageURL,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            !widget.isInterview
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0 * ScreenSize.heightMultiplyingFactor,
                                      horizontal: 8.0 * ScreenSize.widthMultiplyingFactor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 3.0 * ScreenSize.heightMultiplyingFactor,
                                            horizontal: 3.0 * ScreenSize.widthMultiplyingFactor,
                                          ),
                                          child: GestureDetector(
                                            child: Icon(
                                              widget.storyList[index].isBookmarked.contains(UserData.getUserId()) ? Icons.bookmark : Icons.bookmark_border,
                                              color: widget.storyList[index].isBookmarked.contains(UserData.getUserId()) ? primaryColour : Colors.black,
                                              size: 35 * ScreenSize.heightMultiplyingFactor,
                                            ),
                                            onTap: () {
                                              bool valueOfList = widget.storyList[index].isBookmarked.contains(UserData.getUserId());
                                              if (valueOfList) {
                                                firebaseFirestore.collection("Stories").doc(widget.storyList[index].id).update({
                                                  "isBookmarked": FieldValue.arrayRemove([UserData.getUserId()])
                                                });
                                              } else {
                                                firebaseFirestore.collection("Stories").doc(widget.storyList[index].id).update({
                                                  "isBookmarked": FieldValue.arrayUnion([UserData.getUserId()])
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 6.0 * ScreenSize.heightMultiplyingFactor,
                        ),
                        Text(
                          widget.insideWidth == 245.0 * ScreenSize.widthMultiplyingFactor
                              ? widget.storyList[index].title.length > 40 ? widget.storyList[index].title.substring(0, 39) + "..." : widget.storyList[index].title
                              : widget.storyList[index].title.length > 35 ? widget.storyList[index].title.substring(0, 34) + "..." : widget.storyList[index].title,
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 12.0 * ScreenSize.heightMultiplyingFactor,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.storyList[index].author,
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 9.0 * ScreenSize.heightMultiplyingFactor,
                            color: Colors.black54,
                          ),
                        ),
                        !widget.isInterview
                            ? SizedBox(
                                height: 5.0 * ScreenSize.heightMultiplyingFactor,
                              )
                            : SizedBox(),
                        !widget.isInterview
                            ? Wrap(
                                spacing: 5.0 * ScreenSize.widthMultiplyingFactor,
                                children: List<Widget>.generate(
                                  widget.storyList[index].related.length < 3 ? widget.storyList[index].related.length : 3,
                                  (int i) {
                                    return Container(
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
                                      child: Center(
                                        child: Text(
                                          widget.storyList[index].related[i].length > 12 ? widget.storyList[index].related[i].substring(0, 8) + '...' : widget.storyList[index].related[i],
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: 10.0 * ScreenSize.heightMultiplyingFactor,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Text(
                                widget.storyList[index].posted,
                                style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  fontSize: 9.0 * ScreenSize.heightMultiplyingFactor,
                                  color: Colors.black54,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
