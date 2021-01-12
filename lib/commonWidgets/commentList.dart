import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/commentData.dart';

class CommentList extends StatefulWidget {
  final bool hasRating;
  final List<CommentData> commentList;

  const CommentList({Key key, this.hasRating, this.commentList}) : super(key: key);

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    return (widget.commentList == null || widget.commentList.length == 0)
        ? Container(
            height: 120 * ScreenSize.heightMultiplyingFactor,
            child: Center(
              child: Text(
                'No comments yet! Be the first one to comment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins-SemiBold',
                  fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
                  color: primaryColour,
                ),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return userRatings(
                  hasRating: this.widget.hasRating,
                  userName: widget.commentList[index].commentBy,
                  comment: widget.commentList[index].content,
                  commentDate: widget.commentList[index].postedOn,
                  rating: widget.commentList[index].ratingStars);
            },
            itemCount: widget.commentList.length,
          );
  }
}

Widget userRatings(
    {double rating = 1,
    bool hasRating = false,
    String userName = 'UserName',
    String commentDate = '00-00-00',
    String commentTitle = 'Title',
    String comment =
        'Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text Long comment text '}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 15.0 * ScreenSize.widthMultiplyingFactor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 50.0 * ScreenSize.heightMultiplyingFactor,
          indent: 0,
          endIndent: 0,
          thickness: 0.5,
          color: Color(0xFF707070),
        ),
        hasRating
            ? RatingBarIndicator(
                rating: rating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 25.0 * ScreenSize.heightMultiplyingFactor,
              )
            : SizedBox(
                height: 0.0,
              ),
        Padding(
          padding: EdgeInsets.only(
            bottom: 8.0 * ScreenSize.heightMultiplyingFactor,
          ),
          child: Text(
            'By ' + userName + ' on ' + commentDate,
            style: TextStyle(
              fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
              fontFamily: 'Poppins-Regular',
            ),
          ),
        ),
        Text(
          comment,
          style: TextStyle(
            fontSize: 14.0 * ScreenSize.heightMultiplyingFactor,
            fontFamily: 'Poppins-Light',
          ),
        ),
      ],
    ),
  );
}
