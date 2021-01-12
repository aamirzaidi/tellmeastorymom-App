import 'package:flutter/material.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';

class RowViewAll extends StatelessWidget {
  final String heading;
  final Function onpressed;

  const RowViewAll({Key key, this.heading, this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 18.0 * ScreenSize.widthMultiplyingFactor,
        right: 28.0 * ScreenSize.widthMultiplyingFactor,
        bottom: 10.0 * ScreenSize.heightMultiplyingFactor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              color: Colors.black,
              fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
            ),
          ),
          GestureDetector(
            onTap: onpressed,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "View All",
                style: TextStyle(
                 // fontFamily: 'Poppins-Regular',
                  fontWeight: FontWeight.w900,
                  color: Colors.blue,
                  fontSize: 16.0 * ScreenSize.heightMultiplyingFactor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
