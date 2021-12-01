import 'package:cloud_firestore/cloud_firestore.dart';

class StoryData implements Comparable<StoryData> {
  String id;
  String storyImageURL;
  String storyImageURL2;
  String storyImageURL3;
  String storyImageURL4;
  String storyImageURL5;
  String storyImageURL6;
  String title;
  List<String> isBookmarked;
  String author;
  List<String> related;
  String posted;
  dynamic content;
  dynamic content2;
  dynamic content3;
  dynamic content4;
  dynamic content5;
  dynamic content6;
  List<String> isLiked;
  bool isLatest;
  bool isRecommended;
  bool isPopular;

  StoryData(
      {
        this.author,
        this.content,
        this.content2,
        this.content3,
        this.content4,
        this.content5,
        this.content6,
        this.id,
        this.isBookmarked,
        this.isLiked,
        this.isRecommended,
        this.posted,
        this.related,
        this.storyImageURL,
        this.storyImageURL2,
        this.storyImageURL3,
        this.storyImageURL4,
        this.storyImageURL5,
        this.storyImageURL6,
        this.title
      });

  StoryData.fromSnapshot(DocumentSnapshot snapshot) {
    this.author = snapshot.get('author');
    this.content = snapshot.get('content');
    this.id = snapshot.id.toString();

    try{
      this.isBookmarked = snapshot.get('isBookmarked') == null
          ? []
          : snapshot.get('isBookmarked').cast<String>();
    }catch(e){
      this.isBookmarked = [];
    }

    try{
      this.isLiked = snapshot.get('isLiked') == null
          ? []
          : snapshot.get('isLiked').cast<String>();
      this.isRecommended = snapshot.get('isRecommended');
    }catch(e){
      this.isLiked = [];
    }

    try{
      this.content2 = snapshot.get('content2');
    }catch(e){
      this.content2 = "";
    }

    try{
      this.content3 = snapshot.get('content3');
    }catch(e){
      this.content3 = "";
    }

    try{
      this.content4 = snapshot.get('content4');
    }catch(e){
      this.content4 = "";
    }

    try{
      this.content5 = snapshot.get('content5');
    }catch(e){
      this.content5 = "";
    }

    try{
      this.content6 = snapshot.get('content6');
    }catch(e){
      this.content6 = "";
    }

    try{
      this.storyImageURL2 = snapshot.get('storyImageURL2');
    }catch(e){
      this.storyImageURL2 = null;
    }

    try{
      this.storyImageURL3 = snapshot.get('storyImageURL3');
    }catch(e){
      this.storyImageURL3 = null;
    }

    try{
      this.storyImageURL4 = snapshot.get('storyImageURL4');
    }catch(e){
      this.storyImageURL4 = null;
    }

    try{
      this.storyImageURL5 = snapshot.get('storyImageURL5');
    }catch(e){
      this.storyImageURL5 = null;
    }

    try{
      this.storyImageURL6 = snapshot.get('storyImageURL6');
    }catch(e){
      this.storyImageURL6 = null;
    }

    this.posted = snapshot.get('posted');
    this.related = snapshot.get('related').cast<String>();
    this.storyImageURL = snapshot.get('storyImageURL');
    this.title = snapshot.get('title');
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'content': content,
      'isBookmarked': isBookmarked,
      'isLiked': isLiked,
      'isRecommended': isRecommended,
      'posted': "By Tellmeastorymom",
      "related": related,
      'storyImageURL': storyImageURL,
      'title': title,
      'content2' : content2,
      'content3' : content3,
      'content4' : content4,
      'content5' : content5,
      'content6' : content6,
      'storyImageURL2': storyImageURL2,
      'storyImageURL3': storyImageURL3,
      'storyImageURL4': storyImageURL4,
      'storyImageURL5': storyImageURL5,
      'storyImageURL6': storyImageURL6,
    };
  }

  @override
  int compareTo(StoryData other) {
    int y1 = int.parse(this.posted.substring(16));
    int y2 = int.parse(other.posted.substring(16));
    int m1 = int.parse(this.posted.substring(13,15));
    int m2 = int.parse(other.posted.substring(13,15));
    int d1 = int.parse(this.posted.substring(10,12));
    int d2 = int.parse(other.posted.substring(10,12));

    if(y1 != y2){
      return y2 - y1;
    }else if(m1 != m2){
      return m2 - m1;
    }else{
      return d2 - d1;
    }
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
