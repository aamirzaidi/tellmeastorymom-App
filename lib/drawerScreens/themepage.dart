import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/screens/Home.dart';

class ChangeTheme extends StatefulWidget {
  @override
  _ChangeThemeState createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {

  Future setColor(int idx)async{
    await preferences.setInt('color', idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Change Theme"),
        backgroundColor: primaryColour,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                  color: Colors.red,
                  padding: EdgeInsets.all(10.0),
                  child: Text('Red',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.red;
                    setColor(1);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.blue,
                  padding: EdgeInsets.all(10.0),
                  child: Text('Blue',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.blue;
                    setColor(2);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.pink,
                  padding: EdgeInsets.all(10.0),
                  child: Text('Pink',style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.pink;
                    setColor(3);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.green,
                  padding: EdgeInsets.all(10.0),
                  child: Text("Green",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.green;
                    setColor(4);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.blueGrey,
                  padding: EdgeInsets.all(10.0),
                  child: Text("Blue Grey",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.blueGrey;
                    setColor(5);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.all(10.0),
                  child: Text("Dark Blue",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.blueAccent;
                    setColor(6);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.purpleAccent,
                  padding: EdgeInsets.all(10.0),
                  child: Text("Purple",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.purpleAccent;
                    setColor(7);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.deepOrange,
                  padding: EdgeInsets.all(10.0),
                  child: Text("Orange",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.deepOrange;
                    setColor(8);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.amber,
                  padding: EdgeInsets.all(10.0),
                  child: Text("Amber",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.amber;
                    setColor(9);
                    setState(() {});
                  }
              ),
              RaisedButton(
                  color: Colors.teal,
                  padding: EdgeInsets.all(10.0),
                  child: Text("Teal",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    primaryColour = Colors.teal;
                    setColor(10);
                    setState(() {});
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}