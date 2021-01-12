import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/drawerScreens/mompreneurScreens/interviewReading.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/providers/userData.dart';

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class ItemImageCard extends StatefulWidget {
  final double boxHeight;
  final String title;
  final String posted;
  final String author;

  final double insideHeight;
  final double insideWidth;
  final bool itemCard;
  const ItemImageCard({Key key, this.title, this.posted, this.author, this.boxHeight, this.insideHeight, this.story, this.insideWidth, this.assetname, this.itemCard = false}) : super(key: key);

  final StoryData story;
  final String assetname;
  @override
  _ItemImageCardState createState() => _ItemImageCardState();
}

class _ItemImageCardState extends State<ItemImageCard> {
  @override
  Widget build(BuildContext context) {
    TextStyle ts = TextStyle(
      fontFamily: "Poppins-Regular",
      fontSize: 12 * ScreenSize.heightMultiplyingFactor,
    );
    return Container(
      height: 300 * ScreenSize.heightMultiplyingFactor,
      // color: Colors.black,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InterviewReading(story: popularStories[0], isDiary: true),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: widget.insideHeight,
                  width: widget.insideWidth,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 6.0,
                        offset: Offset(0, 3),
                        color: Colors.black.withOpacity(0.16),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                        widget.assetname,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0 * ScreenSize.heightMultiplyingFactor,
                    horizontal: 8.0 * ScreenSize.widthMultiplyingFactor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 3.0 * ScreenSize.heightMultiplyingFactor,
                          horizontal: 3.0 * ScreenSize.widthMultiplyingFactor,
                        ),
                        child: GestureDetector(
                          child: Icon(
                            widget.story.isBookmarked.contains(UserData.getUserId()) ? Icons.bookmark : Icons.bookmark_border,
                            color: widget.story.isBookmarked.contains(UserData.getUserId()) ? primaryColour : Colors.black,
                            size: 24 * ScreenSize.heightMultiplyingFactor,
                          ),
                          onTap: () {
                            bool valueOfList = widget.story.isBookmarked.contains(UserData.getUserId());
                            if (valueOfList) {
                              firebaseFirestore.collection("Stories").doc(widget.story.id).update({
                                "isBookmarked": FieldValue.arrayRemove([UserData.getUserId()])
                              });
                            } else {
                              firebaseFirestore.collection("Stories").doc(widget.story.id).update({
                                "isBookmarked": FieldValue.arrayUnion([UserData.getUserId()])
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 9.0 * ScreenSize.heightMultiplyingFactor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 16 * ScreenSize.heightMultiplyingFactor, fontFamily: "Poppins-Regular"),
                ),
                Text(
                  widget.author,
                  style: ts,
                ),
                Text(widget.posted, style: ts),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
