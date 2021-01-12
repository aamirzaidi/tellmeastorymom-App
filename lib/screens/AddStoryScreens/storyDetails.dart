import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/providers/db.dart';
import 'package:tellmeastorymom/providers/storyData.dart';
import 'package:tellmeastorymom/screens/Home.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StoryDetails extends StatefulWidget {
  StoryDetails({Key key}) : super(key: key);

  @override
  _StoryDetailsState createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
  final globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController title = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String language;
  List<String> chosenCategories = new List<String>();
  List<String> categories = new List<String>();
  int size = 1;
  DatabaseService databaseService = new DatabaseService();

  File image;
  String uploadedFileURL;
  final picker = ImagePicker();

  void _startPickingImage(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: ctx,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListTile(
                  dense: true,
                  trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          image = null;
                        });
                        Navigator.of(ctx).pop();
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.black45,
                      )),
                  title: Text(
                    'Choose An Option',
                    style: TextStyle(
                        fontFamily: "Gilroy",
                        color: Colors.black45,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            //SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Colors.redAccent,
                      ),
                      onPressed: pickImageFromCamera,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        size: 30,
                        color: Colors.redAccent,
                      ),
                      onPressed: pickImageFromGallary,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Future pickImageFromGallary() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

  }

  Future pickImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadFile(File img) async {
    var path = img.path;
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('storyThumbnail/${path.split("/").last}}}');
    UploadTask uploadTask = storageReference.putFile(img);
    await uploadTask.whenComplete(() async {
      print('File Uploaded');
      uploadedFileURL = await storageReference.getDownloadURL();
    });
  }


  @override
  void initState() {
    fetchCategories();
    super.initState();
  }

  void fetchCategories() async {
    categories = await databaseService.getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: primaryColour,
          leading: Container(),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 24.0, bottom: 16, left: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      // iconSize: 20,
                      color: Colors.white,
                    ),
                    Spacer(),
                    FlatButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          String doc = await _loadDocument();

                          QuerySnapshot snapshot =
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .where(
                                    'email',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser.email,
                                  )
                                  .get();
                          String author =
                              await snapshot.docs.first.data()['displayName'];

                          globalKey.currentState.showSnackBar(SnackBar(content: Text('Uploading, Please Wait !!',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)));

                          //Upload Image Code
                          if(image!=null){
                            await uploadFile(image);
                          }

                          print(uploadedFileURL);

                          StoryData storyData = new StoryData(
                            title: title.text,
                            posted:
                                'Posted on ${getMonthName(DateTime.now().month)} ${DateTime.now().day}, ${DateTime.now().year}',
                            content: doc,
                            related: chosenCategories,
                            author: author,
                            storyImageURL: uploadedFileURL ?? 'https://scontent.fdel5-1.fna.fbcdn.net/v/t1.0-9/22279431_1412480745495450_4240890917957906218_n.png?_nc_cat=107&ccb=2&_nc_sid=09cbfe&_nc_ohc=V8e_4warmcIAX-AoAOn&_nc_ht=scontent.fdel5-1.fna&oh=41ea8be45d3daeaa0d3a279eb1c272d1&oe=5FFB7E1F',
                          );

                          DatabaseService databaseService =
                          new DatabaseService();
                          try{
                            await databaseService.uploadPendingSory(storyData);
                            print('Story Uploaded');
                            globalKey.currentState.showSnackBar(SnackBar(content: Text('Your story is sent to admin and will become online after being approved!!',
                              style: TextStyle(color: primaryColour,fontWeight: FontWeight.bold),
                            )));
                          }catch(e){
                            globalKey.currentState.showSnackBar(SnackBar(content: Text('Some Error Occured')));
                          }


                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ),
                                  (Route<dynamic> route) => false);
                        }
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins-Regular',
                        ),
                      ),
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Story Details',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: title,
                      decoration: const InputDecoration(
                        hintText: 'Awesome story title',
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value.length < 1) {
                          return 'Title cannot be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Text('Language'),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (language == null) {
                          return 'Please select a language';
                        }
                        return null;
                      },
                      hint: Text('Select Language'),
                      items: [
                        DropdownMenuItem(
                          child: Text('English'),
                          value: 'English',
                        ),
                        DropdownMenuItem(
                          child: Text('Hindi'),
                          value: 'Hindi',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          language = value;
                        });
                      },
                    ),
                    for (var i = 0; i < size; i++) categoryWidget(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            size++;
                          });
                        },
                        child: Text(
                          'Add new category +',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30)),
                                  contentPadding: EdgeInsets.all(0),
                                  actionsPadding: EdgeInsets.all(0),
                                  content: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.add_a_photo,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            pickImageFromCamera();
                                          }),
                                      Container(
                                          height: 50,
                                          child: VerticalDivider(
                                            thickness: 1,
                                          )),
                                      IconButton(
                                          icon: Icon(
                                            Icons.add_photo_alternate,
                                            size: 30,
                                          ),
                                          onPressed: ()  {
                                            Navigator.pop(context);
                                            pickImageFromGallary();
                                          }),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: TextFormField(
                          enabled: false,
                          style: TextStyle(fontSize: 20.0),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: image == null
                                    ? Colors.black
                                    : Colors.green),
                            hintText: image == null
                                ? "Select Image"
                                : "Image Selected",
                            suffixIcon: Icon(Icons.add),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _startPickingImage(context);
                      },
                      child: Container(
                        color: Colors.grey[400],
                        child: image == null
                            ? Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width - 100,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  size: 100,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Add Image',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "Gilroy",
                                      fontWeight: FontWeight.w600),
                                )
                                //SizedBox(height:height*0.06),
                              ]),
                        )
                            : Image(
                            height: 200,
                            width: MediaQuery.of(context).size.width - 60,
                            fit: BoxFit.cover,
                            image: FileImage(image)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column categoryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
        ),

        Text('Category'),
        DropdownButtonFormField(
          validator: (value) {
            if (chosenCategories.isEmpty) {
              return 'Select at least 1 category';
            }
            return null;
          },
          hint: Text('Select Category'),
          items: categories.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          // value: 'Select',
          onChanged: (value) {
            setState(() {
              if (!chosenCategories.contains(value)) {
                chosenCategories.add(value);
                // categories.remove(value);
              }
            });
          },
        ),
        // FlatButton(onPressed: null, child: null)
      ],
    );
  }

  Future<String> _loadDocument() async {
    final file = File(Directory.systemTemp.path + "/story.json");
    if (await file.exists()) {
      final contents = await file.readAsString();
      return contents;
    }
  }
}
