import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

class DatabaseService {
  final CollectionReference storiesRef =
      FirebaseFirestore.instance.collection('Stories');

  final CollectionReference categoriesRef =
      FirebaseFirestore.instance.collection('categories');

  final CollectionReference pendingStoriesRef =
      FirebaseFirestore.instance.collection('PendingStories');

  Future<DocumentReference> uploadPendingSory(StoryData storyData) async {
    DocumentReference documentReference;
    try {
      documentReference = await pendingStoriesRef.add({
        'author': storyData.author,
        'content': storyData.content,
        'posted': storyData.posted,
        'related': storyData.related,
        'title': storyData.title,
        'storyImageURL' : storyData.storyImageURL,
        'isLatest': true,
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<DocumentReference> uploadStory(StoryData storyData) async {
    DocumentReference documentReference;
    try {
      documentReference = await storiesRef.add({
        'author': storyData.author,
        'content': storyData.content,
        'posted': storyData.posted,
        'related': storyData.related,
        'title': storyData.title,
        'storyImageURL' : storyData.storyImageURL,
        'isLatest': true,
      });
    } on FirebaseException catch (e) {
      print(e);
    }
    for (var category in storyData.related) {
      QuerySnapshot snap =
          await categoriesRef.where('categoryName', isEqualTo: category).get();
      snap.docs.first.reference.update(
        {
          'categoryStories': FieldValue.arrayUnion(
            [documentReference.id],
          ),
        },
      );
    }
  }

  Future<List<String>> getCategoryList() async {
    List<String> categories = new List<String>();
    final data = await categoriesRef.get();
    var docs = data.docs;
    for (var doc in docs) {
      categories.add(doc.data()['categoryName']);
    }
    return categories;
  }
}
