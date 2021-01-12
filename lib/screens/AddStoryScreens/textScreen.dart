import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/screens/AddStoryScreens/storyDetails.dart';
import 'package:zefyr/zefyr.dart';

class TextScreen extends StatefulWidget {
  TextScreen({Key key}) : super(key: key);

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  bool emptyDoc = true;

  ZefyrController controller;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    controller = ZefyrController(document);
    focusNode = FocusNode();
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert('\n');
    return NotusDocument.fromDelta(delta);
  }

  void checkDoc() {
    emptyDoc = controller.document.length > 1 ? false : true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkDoc();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Builder(
          builder: (context) => AppBar(
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
                          if (controller.document.length < 2) {
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Empty story'),
                                  content: Text(
                                      'The story cannot be completely empty'),
                                );
                              },
                            );
                          } else
                            print('object');
                        },
                        child: Text(
                          'Save draft',
                          style: TextStyle(
                            fontFamily: 'Poppins-Light',
                          ),
                        ),
                        color: Colors.amber[200],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FlatButton(
                        onPressed: () async {
                          if (controller.document.length < 2) {
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Empty story'),
                                  content: Text(
                                    'The story cannot be completely empty',
                                  ),
                                );
                              },
                            );
                          } else {
                            final contents = controller.document.toPlainText();
                            final file =
                                File(Directory.systemTemp.path + "/story.json");
                            await file.writeAsString(contents).then((_) {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text("Saved.")));
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryDetails(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Next',
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
      ),
      body: Container(
        child: ZefyrScaffold(
          child: ZefyrEditor(
            controller: controller,
            focusNode: focusNode,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Future<void> _saveDocument(BuildContext context) async {
    final contents = controller.document.toPlainText();
    final file = File(Directory.systemTemp.path + "/story.json");
    await file.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
    });
  }
}
