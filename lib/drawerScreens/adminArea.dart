import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/db.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:tellmeastorymom/screens/AddStoryScreens/editScreen.dart';

import 'delete_category_page.dart';

class AdminArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColour,
          title: Text(
            "Stories Pending For Approval",
            style: TextStyle(
              fontFamily: 'Poppins-SemiBold',
              fontSize: 18.0 * ScreenSize.widthMultiplyingFactor,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Column(
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                    child: Text('Add Another Category', style: TextStyle(color: Colors.lightBlue),),
                    onPressed: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            final myController = TextEditingController();
                            return Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: TextField(
                                      controller: myController,),
                                  ),
                                  Text('Add New Category', style: TextStyle(fontSize: 17.0,),),
                                  SizedBox(height: 10.0,),
                                  OutlinedButton(onPressed: () async{
                                    print(myController.text);
                                    if(myController.text.length < 4){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Length should be atleast 4 charcaters long'),
                                      ));
                                      print('Length should be atleast 4 charcaters long');
                                    }else{
                                      DatabaseService databaseService =
                                      new DatabaseService();
                                      bool success = await databaseService.addCategory(myController.text);
                                      if(success){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Category Added')));
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Error in adding! Try again')));
                                      }
                                    }
                                    Navigator.pop(context);
                                  }, child: Text('Add category'))
                                ],
                              ),
                            );
                          });
                    },
                  ),
                  OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => deleteCategoryPage()));
                      },
                      child: Text('Delete Category', style: TextStyle(color: Colors.lightBlue)))
                ],
              ),
            ),
          ),
        ),
        body: PendingStoriesPage());
  }
}

class PendingStoriesPage extends StatefulWidget {
  @override
  _PendingStoriesPageState createState() => _PendingStoriesPageState();
}

class _PendingStoriesPageState extends State<PendingStoriesPage> {
  List<Color> getGradientColor(index) {
    if (index == 0) {
      return [Colors.black, Colors.blueAccent];
    } else if (index == 1) {
      return [Colors.black, Colors.red];
    } else if (index == 2) {
      return [Colors.black, Colors.green];
    } else if (index == 3) {
      return [Colors.black, Colors.amber];
    } else if (index % 4 == 0) {
      return [Colors.black, Colors.blueGrey];
    } else if (index % 5 == 0) {
      return [Colors.black, Colors.cyan];
    } else if (index % 6 == 0) {
      return [Colors.black, Colors.deepPurpleAccent];
    } else if (index % 3 == 0) {
      return [Colors.black, Colors.blue.shade900];
    } else if (index % 2 == 0) {
      return [Colors.black, Colors.brown];
    } else {
      return [Colors.black, Colors.redAccent];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("PendingStories").snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Container(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Something Wrong'),
          );
        }
        return Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {

                  if (!snapshot.hasData) {
                    return circularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something Wrong'),
                    );
                  }

                  if(snapshot.data.docs.length==0){
                    return Center(child: Text('No Stories Uploaded',style: TextStyle(fontSize: 30.0,color: primaryColour),),);
                  }

                  return PendingStoryCard(
                    title: snapshot.data.docs[index].get('title'),
                    content: snapshot.data.docs[index].get('content'),
                    author: snapshot.data.docs[index].get('author'),
                    imageUrl: snapshot.data.docs[index].get('storyImageURL'),
                    isLatest: snapshot.data.docs[index].get('isLatest'),
                    posted: snapshot.data.docs[index].get('posted'),
                    related: snapshot.data.docs[index].get('related'),
                    gradientColors: [primaryColour,Color(0xff861657)],
                    arrowColor: primaryColour,

                    approveCallBack: ()async{
                      StoryData storyData = StoryData.fromSnapshot(snapshot.data.docs[index]);

                      DatabaseService databaseService =
                      new DatabaseService();
                        await databaseService.uploadStory(storyData);

                      var documentID = snapshot.data.docs[index].id;
                      FirebaseFirestore.instance.collection('PendingStories').doc(documentID).delete();
                      setState(() {});
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Story Added!')));
                    },

                    deleteCallBack: (){
                      var documentID = snapshot.data.docs[index].id;
                      FirebaseFirestore.instance.collection('PendingStories').doc(documentID).delete();
                      setState(() {});
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Story Deleted!')));
                    },
                    editContentCallBack: ()async{
                      var documentID = snapshot.data.docs[index].id;
                      var editStorySnapshot = await FirebaseFirestore.instance.collection('PendingStories').doc(documentID).get();
                      String contentToEdit = editStorySnapshot.get('content');
                      print("content  =  $contentToEdit");
                      Navigator.push(context, MaterialPageRoute(builder: (content) => EditScreen(
                        fieldName: 'content',
                        docID: documentID,
                        content: contentToEdit,
                        collectionName: 'PendingStories',
                      )));
                    },
                    editTitleCallBack: ()async{
                    var documentID = snapshot.data.docs[index].id;
                    var editStorySnapshot = await FirebaseFirestore.instance.collection('PendingStories').doc(documentID).get();
                    String titleToEdit = editStorySnapshot.get('title');
                    print("content  =  $titleToEdit");
                    Navigator.push(context, MaterialPageRoute(builder: (content) => EditScreen(
                      fieldName: 'title',
                      docID: documentID,
                      content: titleToEdit,
                      collectionName: 'PendingStories',
                    )));
                  },

                  );
                }));
      },
    );
  }
}

// ignore: must_be_immutable
class PendingStoryCard extends StatelessWidget {
  PendingStoryCard(
      {
        this.title,
        this.author,
        this.content,
        this.isLatest,
        this.gradientColors,
        this.arrowColor = Colors.blueAccent,
        this.posted,
        this.imageUrl,
        this.related,
        this.deleteCallBack,
        this.approveCallBack,
        this.editContentCallBack,
        this.editTitleCallBack,
      });

  final related;
  final content;
  final posted;
  final isLatest;
  final author;
  final title;
  final imageUrl;
  final gradientColors;
  final arrowColor;

  Function deleteCallBack;
  Function approveCallBack;
  Function editContentCallBack;
  Function editTitleCallBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 135,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors,),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  fontFamily: 'Gilroy'),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              "By- $author",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                  fontFamily: 'Gilroy'),
                            ),
                            SizedBox(height: 10,),

                          ],
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 135,
                      color: Colors.transparent,
                      child: Image(
                        image: NetworkImage(
                          imageUrl,
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ExpandChild(
              arrowSize: 30.0,
              arrowColor: arrowColor,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        left: BorderSide(color: arrowColor, width: 10.0),
                        right: BorderSide(color: arrowColor, width: 10.0))),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 100.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            content,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Colors.black,
                              fontSize: 16.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ButtonBar(
                    children: [
                      RaisedButton(
                        color: Colors.blue,
                        child: Text('Approve',style: TextStyle(color: Colors.white),),
                        onPressed: approveCallBack,
                      ),
                      RaisedButton(
                        color: Colors.redAccent,
                        child: Text('Disapprove',style: TextStyle(color: Colors.white),),
                        onPressed: deleteCallBack,
                      ),
                      RaisedButton(
                        color: Colors.green,
                        child: Text('Edit',style: TextStyle(color: Colors.white),),
                        onPressed: editContentCallBack,
                      ),
                      RaisedButton(
                        color: Colors.deepOrangeAccent,
                        child: Text('Edit Title',style: TextStyle(color: Colors.white),),
                        onPressed: editTitleCallBack,
                      ),
                    ],
                    mainAxisSize: MainAxisSize.max,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
