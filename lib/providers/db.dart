import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

class DatabaseService {
  final CollectionReference storiesRef =
      FirebaseFirestore.instance.collection('Stories');

  final CollectionReference categoriesRef =
      FirebaseFirestore.instance.collection('categories');

  final CollectionReference pendingStoriesRef =
      FirebaseFirestore.instance.collection('PendingStories');

  Future<bool> deleteCategory(id) async{
    try{
      await categoriesRef.doc(id).delete();
      return true;
    }catch(e){
      print('$e : Error Catch');
      return false;
    }
  }


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
        'content2': storyData.content2 ?? "",
        'content3': storyData.content3 ?? "",
        'content4': storyData.content4 ?? "",
        'content5': storyData.content5 ?? "",
        'content6': storyData.content6 ?? "",
        'posted': storyData.posted,
        'related': storyData.related,
        'title': storyData.title,
        'storyImageURL' : storyData.storyImageURL ?? null,
        'storyImageURL2' : storyData.storyImageURL2 ?? null,
        'storyImageURL3' : storyData.storyImageURL3 ?? null,
        'storyImageURL4' : storyData.storyImageURL4 ?? null,
        'storyImageURL5' : storyData.storyImageURL5 ?? null,
        'storyImageURL6' : storyData.storyImageURL6 ?? null,
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
      categories.add(doc.get('categoryName'));
    }
    return categories;
  }

  Future<bool> addCategory(String categoryName) async {
    try{
      await categoriesRef.add(
        {
          'categoryName' : categoryName,
          'categoryStories' : [],
        });

      return true;
    }catch(e){
      print('$e : Error Catch');
      return false;
    }
  }
}
