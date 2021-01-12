import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/commonWidgets/CommonCardViewScreen.dart';
import 'package:tellmeastorymom/commonWidgets/HomeScreenCardView.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/db.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:tellmeastorymom/providers/storyData.dart';

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
                  print(snapshot.data.docs.length);
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
                   // email: snapshot.data.docs[index].get('email'),
                    related: snapshot.data.docs[index].get('related'),
                    gradientColors: [primaryColour,Color(0xff861657)],
                    arrowColor: primaryColour,

                    approveCallBack: ()async{
                      final chosenCategories = snapshot.data.docs[index].get('related');

                      StoryData storyData = new StoryData(
                        title: snapshot.data.docs[index].get('title'),

                        posted:
                        'Posted on ${getMonthName(DateTime.now().month)} ${DateTime.now().day}, ${DateTime.now().year}',
                        content: snapshot.data.docs[index].get('content'),
                        related: chosenCategories.cast<String>(),
                        author: snapshot.data.docs[index].get('author'),
                        storyImageURL: snapshot.data.docs[index].get('storyImageURL'),
                      );

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
                  );
                }));
      },
    );
  }
}

class PendingStoryCard extends StatelessWidget {

  PendingStoryCard(
      {
        this.title,
        this.author,
       // this.email,
        this.content,
        this.isLatest,
        this.gradientColors,
        this.arrowColor = Colors.blueAccent,
        this.posted,
        this.imageUrl,
        this.related,
        this.deleteCallBack,
        this.approveCallBack,
      });

  final related;
  final content;
  final posted;
  final isLatest;
  final author;
  final title;
 // final email;
  final imageUrl;
  final gradientColors;
  final arrowColor;

  Function deleteCallBack;
  Function approveCallBack;

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
                        gradient: LinearGradient(
                          colors: gradientColors,
                        ),
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
