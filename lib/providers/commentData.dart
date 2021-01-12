import 'package:cloud_firestore/cloud_firestore.dart';

class CommentData {
  String commentBy;
  String content;
  String postedOn;
  String id;
  double ratingStars;

  CommentData(
      {this.commentBy, this.content, this.id, this.postedOn, this.ratingStars});

  CommentData.fromSnapshot(DocumentSnapshot snapshot) {
    this.commentBy = snapshot.data()['commentBy'];
    this.content = snapshot.data()['content'];
    this.postedOn = snapshot.data()['postedOn'];
    this.ratingStars = double.parse(snapshot.data()['ratingStars'].toString());
    this.id = snapshot.id.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'commentBy': commentBy,
      'content': content,
      'postedOn': postedOn,
      'ratingStars': ratingStars,
    };
  }
}
