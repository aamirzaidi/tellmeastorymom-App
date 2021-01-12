import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tellmeastorymom/constants/constant.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/screens/Home.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<String> name = ['Read', 'Explore'];
  List<String> content = [
    'Interesting stories on\nyour favourite topics',
    'A collection of stories everday.\nRead, Enjoy & Grow.',
  ];

  PageController pageController;
  int nextValue = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Positioned(
                top: 0.0 * ScreenSize.heightMultiplyingFactor,
                left: 0.0 * ScreenSize.widthMultiplyingFactor,
                right: 0.0 * ScreenSize.widthMultiplyingFactor,
                child: Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.white,
                  child: PageView.builder(
                    itemCount: 2,
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        nextValue = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/onboarding' + (index == 0 ? '1.png' : '2.png'),
                            height: 450.0 * ScreenSize.heightMultiplyingFactor,
                            width: index == 0 ? size.width + 200.0 * ScreenSize.widthMultiplyingFactor : 330.0 * ScreenSize.widthMultiplyingFactor,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 53.0 * ScreenSize.heightMultiplyingFactor,
                          ),
                          Text(
                            name[index],
                            style: TextStyle(
                              fontFamily: 'Poppins-SemiBold',
                              fontSize: 28.0 * ScreenSize.heightMultiplyingFactor,
                              color: primaryColour,
                            ),
                          ),
                          SizedBox(
                            height: 10.0 * ScreenSize.heightMultiplyingFactor,
                          ),
                          Text(
                            content[index],
                            style: TextStyle(
                              fontFamily: 'Poppins-Regular',
                              fontSize: 16.0 * ScreenSize.heightMultiplyingFactor,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // SizedBox(
//                           height: 60.0*ScreenSize.heightMultiplyingFactor,
                          // ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: size.height,
                width: size.width,
                padding: EdgeInsets.only(bottom: 50.0 * ScreenSize.heightMultiplyingFactor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlineButton(
                      borderSide: BorderSide(
                        color: primaryColour,
                        width: 1.0 * ScreenSize.widthMultiplyingFactor,
                      ),
                      onPressed: () async {
                        if (nextValue != 1) {
                          pageController.animateToPage(1, duration: Duration(milliseconds: 700), curve: Curves.easeInToLinear);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setInt("initScreen3", 1);
                        }
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontFamily: 'Poppins-Bold',
                          color: primaryColour,
                          fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    SizedBox(
                      height: 13.0 * ScreenSize.heightMultiplyingFactor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                        2,
                        _buildDot,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    // double selectedness = Curves.easeOut.transform(
    //   max(
    //     0.0,
    //     1.0 - ((page ?? 0) - index).abs(),
    //   ),
    // );
    // double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return Container(
      width: 20.0 * ScreenSize.widthMultiplyingFactor,
      margin: EdgeInsets.only(right: index == 0 ? 10.0 * ScreenSize.widthMultiplyingFactor : 0.0 * ScreenSize.widthMultiplyingFactor),
      child: Center(
        child: Material(
          color: index == nextValue ? primaryColour : primaryColour.withOpacity(0.18),
          type: MaterialType.circle,
          child: Container(
            width: 20.0 * ScreenSize.widthMultiplyingFactor,
            height: 20.0 * ScreenSize.heightMultiplyingFactor,
          ),
        ),
      ),
    );
  }
}
