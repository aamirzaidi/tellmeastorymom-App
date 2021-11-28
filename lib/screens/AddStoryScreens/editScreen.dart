import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';

class EditScreen extends StatefulWidget {
  final content;
  final docID;
  final fieldName;
  final collectionName;

  EditScreen({
    @required this.content,
    @required this.docID,
    @required  this.fieldName,
    @required this.collectionName
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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
    final delta = Delta()..insert(widget.content + '\n');
    return NotusDocument.fromDelta(delta);
  }

  void checkDoc() {
    emptyDoc = controller.document.length > 1 ? false : true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future editDone(String contents) async{
    await FirebaseFirestore.instance.collection(widget.collectionName).doc(widget.docID).update({
      "${widget.fieldName}" : contents,
    });
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
                        color: Colors.white,
                      ),
                      Spacer(),
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
                                    'The ${widget.fieldName} cannot be completely empty',
                                  ),
                                );
                              },
                            );
                          } else {
                            final contents = controller.document.toPlainText();
                            editDone(contents).then((value) {
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('${widget.fieldName} Edited')));
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Text(
                          'Done',
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
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ZefyrEditor(
                  controller: controller,
                ),
              ),
            ),
            ZefyrToolbar.basic(controller: controller,
              hideCodeBlock: true,
              hideLink: true,
              hideHorizontalRule: true,),
          ],
      ),
    ),
      resizeToAvoidBottomInset: true,
    );
  }
}