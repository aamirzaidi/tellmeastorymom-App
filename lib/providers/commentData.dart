import 'package:cloud_firestore/cloud_firestore.dart';

class CommentData {
  String commentBy;
  String content;
  String postedOn;
  String id;
  String storyId;
  double ratingStars;

  CommentData(
      {this.commentBy, this.content, this.id, this.postedOn, this.ratingStars,this.storyId});

  CommentData.fromSnapshot(DocumentSnapshot snapshot) {
    this.commentBy = snapshot.get('commentBy');
    this.content = snapshot.get('content');
    this.postedOn = snapshot.get('postedOn');
    this.ratingStars = double.parse(snapshot.get('ratingStars').toString());
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
