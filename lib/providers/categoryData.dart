import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryData {
  String id;
  String categoryName;
  List<String> categoryStories;

  CategoryData({this.categoryName, this.categoryStories, this.id});

  CategoryData.fromSnapshot(DocumentSnapshot snapshot) {
    this.categoryName = snapshot.data()['categoryName'];
    this.categoryStories = snapshot.data()['categoryStories'] == null
        ? []
        : snapshot.data()['categoryStories'].cast<String>();
    this.id = snapshot.id.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'catcategoryName': categoryName,
      'categoryStories': categoryStories,
      'id': id,
    };
  }
}

List<CategoryData> categories = [];
