import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/screens/AddStoryScreens/storyDetails.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';
import 'package:url_launcher/url_launcher.dart';

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
    print(controller.document.toPlainText());
    focusNode = FocusNode();
  }

  NotusDocument _loadDocument() {
    final Delta delta = Delta()..insert('\n');
    return NotusDocument.fromDelta(delta);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      OutlinedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () async {
                          launch(
                              "https://www.tellmeastorymom.com/addMultipleStory");
                        },
                        child: Text(
                          'Add Story With Multiple Images',
                          style: TextStyle(
                            fontFamily: 'Poppins-Light',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      OutlinedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryDetails(storyContent: controller.document.toPlainText()),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
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
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ZefyrEditor(
                  focusNode: focusNode,
                  controller: controller,
                ),
              ),
            ),
            ZefyrToolbar.basic(
              controller: controller,
              hideCodeBlock: true,
              hideLink: true,
              hideHorizontalRule: true,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}


