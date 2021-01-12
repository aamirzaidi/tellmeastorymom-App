import 'package:flutter/material.dart';

Color primaryColour = Colors.blue;
const physicsForApp = BouncingScrollPhysics();

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'January';
      break;
    case 2:
      return 'February';
      break;
    case 3:
      return 'March';
      break;
    case 4:
      return 'April';
      break;
    case 5:
      return 'May';
      break;
    case 6:
      return 'June';
      break;
    case 7:
      return 'July';
      break;
    case 8:
      return 'August';
      break;
    case 9:
      return 'September';
      break;
    case 10:
      return 'October';
      break;
    case 11:
      return 'November';
      break;
    case 12:
      return 'December';
      break;
    // default
  }
  return '';
}

Color getColorIndex(int idx) {
  switch (idx) {
    case 1:
      return Colors.red;
      break;
    case 2:
      return Colors.blue;
      break;
    case 3:
      return Colors.pink;
      break;
    case 4:
      return Colors.green;
      break;
    case 5:
      return Colors.blueGrey;
      break;
    case 6:
      return Colors.blueAccent;
      break;
    case 7:
      return Colors.purpleAccent;
      break;
    case 8:
      return Colors.orangeAccent;
      break;
    case 9:
      return Colors.amber;
      break;
    case 10:
      return Colors.teal;
      break;
  // default
  }
  return Colors.blue;
}

Widget appBarOverall(
    {String heading, bool searchThere = true, Function() onPressed}) {
  return AppBar(
    backgroundColor: primaryColour,
    title: Text(
      heading,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(20.0),
        bottomLeft: Radius.circular(20.0),
      ),
    ),
    actions: searchThere
        ? [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: onPressed,
            )
          ]
        : [],
  );
}

Widget circularProgressIndicator({col = const Color(0xFF1a0dab)}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(col),
    ),
  );
}

// const defaultWidth = 411.42857142857144;
const defaultWidth = 375.0;
// const defaultHeight = 774.8571428571429;
const defaultHeight = 812.0;
const defaultSize = Size(defaultWidth, defaultHeight);
