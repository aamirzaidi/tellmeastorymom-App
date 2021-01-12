import 'package:cloud_firestore/cloud_firestore.dart';

class StoryData {
  String id;
  String storyImageURL;
  String title;
  List<String> isBookmarked;
  String author;
  List<String> related;
  String posted;
  String estimated;
  dynamic content;
  List<String> isLiked;
  bool isLatest;
  bool isRecommended;
  bool isPopular;
  //String email;

  StoryData(
      {this.author,
       // this.email,
      this.content,
      this.estimated,
      this.id,
      this.isBookmarked,
      this.isLiked,
      this.isLatest,
      this.isPopular,
      this.isRecommended,
      this.posted,
      this.related,
      this.storyImageURL,
      this.title});

  StoryData.fromSnapshot(DocumentSnapshot snapshot) {
    this.author = snapshot.data()['author'];
    this.content = snapshot.data()['content'];
    //this.email=snapshot.data()['email'];
    this.estimated = snapshot.data()['estimated'] ?? null;
    this.id = snapshot.id.toString();
    this.isBookmarked = snapshot.data()['isBookmarked'] == null
        ? []
        : snapshot.data()['isBookmarked'].cast<String>();
    this.isLiked = snapshot.data()['isLiked'] == null
        ? []
        : snapshot.data()['isLiked'].cast<String>();
    this.isLatest = snapshot.data()['isLatest'];
    this.isPopular = snapshot.data()['isPopular'];
    this.isRecommended = snapshot.data()['isRecommended'];
    this.posted = snapshot.data()['posted'];
    this.related = snapshot.data()['related'].cast<String>();
    this.storyImageURL = snapshot.data()['storyImageURL'];
    this.title = snapshot.data()['title'];
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
      //'email':email,
      'estimated': estimated,
      'isBookmarked': isBookmarked,
      'isLiked': isLiked,
      'isPopular': isPopular,
      'posted': "By Tellmeastorymom",
      "related": related,
      'storyImageURL': storyImageURL,
      'title': title,
    };
  }
}

List<StoryData> allStories = [];
List<StoryData> popularStories = [];
List<StoryData> recommendedStories = [];
List<StoryData> latestStories = [];
List<StoryData> likedStories = [];
List<StoryData> guestStories = [];
List<StoryData> recentlyViewedStories = [];
List<StoryData> bookmarkedStories = [];
List<StoryData> pendingStories = [];
List<StoryData> myStories = [];
