import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/db.dart';

// ignore: camel_case_types
class deleteCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Delete Category",
          style: TextStyle(
            fontFamily: 'Poppins-SemiBold',
            fontSize: 25.0,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25.0),
            bottomLeft: Radius.circular(25.0),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(160),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('⚠ Warning ⚠\nOnly Delete a category if you added it by mistake or there are not more than one or two stories of that category.\nDeleting in any other case might create problems with the database.',
            style: TextStyle(color: Colors.yellowAccent, fontSize: 20.0, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
        FirebaseFirestore.instance.collection("categories").snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Something Wrong'),
            );
          }

          return ListView.builder(
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
                  return Center(child: Text('No Categories',style: TextStyle(fontSize: 30.0,color: primaryColour),),);
                }

                return ListTile(
                  title: Text(snapshot.data.docs[index].get('categoryName')),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => showDialog(context: context, builder: (_) =>  AlertDialog(
                        title: Text('Are you sure you want to delete this category?'),
                        content: Text('⚠ Warning ⚠\nOnly Delete a category if you added it by mistake or there are not more than one or two stories of that category.\nDeleting in any other case might create problems with the database.'),
                        actions: [
                          ElevatedButton(onPressed: () async {
                            var docId = snapshot.data.docs[index].id;
                            DatabaseService databaseService = new DatabaseService();
                            bool success = await databaseService.deleteCategory(docId);
                            if(success){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Category Deleted')));
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Error Occured! Try again')));
                            }
                            Navigator.pop(context);

                          }, child: Text('Yes')),
                          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('No'))
                    ],
                  ),)
                  ),
                );
              }
          );
        },
      ),
    );
  }
}
