import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tellmeastorymom/constants/screenSize.dart';
import 'package:tellmeastorymom/providers/authentication.dart';
import 'package:tellmeastorymom/screens/OnBoardingScreen.dart';

import '../constants/constant.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showNormalPassword = false;
  bool showConfirmPassword = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userName;
  String phoneNumber;
  String email;
  String password;
  bool _autoValidate = false;

  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 774 * ScreenSize.heightMultiplyingFactor,
            padding: EdgeInsets.only(
              left: 20.0 * ScreenSize.widthMultiplyingFactor,
              right: 20.0 * ScreenSize.widthMultiplyingFactor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                          color: primaryColour,
                          fontSize: 26 * ScreenSize.heightMultiplyingFactor,
                          fontFamily: "Poppins-Bold"),
                    ),
                    Text(
                      "Let's Create account First",
                      style: TextStyle(
                        color: primaryColour,
                        fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                        fontFamily: "Poppins-SemiBold",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0 * ScreenSize.heightMultiplyingFactor,
                ),
                Form(
                  key: _formkey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0 * ScreenSize.widthMultiplyingFactor,
                            vertical: 5.0 * ScreenSize.heightMultiplyingFactor),
                        child: TextFormField(
                          onSaved: (val) {
                            userName = val;
                          },
                          validator: (val) {
                            if (val.length < 3) {
                              return " Username is too short";
                            } else if (val.contains(' ') == false &&
                                val.contains(
                                    RegExp('r[A-Z]'), val.indexOf(' ') + 1)) {
                              return " Please Enter Full Name";
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.check,
                              size: 20 * ScreenSize.heightMultiplyingFactor,
                              color: Colors.black,
                            ),
                            labelText: "Full name",
                            labelStyle: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0 * ScreenSize.widthMultiplyingFactor,
                            vertical: 5.0 * ScreenSize.heightMultiplyingFactor),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (val) {
                            if (val.length < 10) {
                              return "10 Digits Mobile Number Required";
                            } else
                              return null;
                          },
                          onSaved: (val) => phoneNumber = val,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                         //   prefixText: "+91-",
                            labelStyle: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                            ),
                            suffixIcon: Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20 * ScreenSize.heightMultiplyingFactor,
                            ),
                            labelText: "Phone Number",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0 * ScreenSize.widthMultiplyingFactor,
                            vertical: 5.0 * ScreenSize.heightMultiplyingFactor),
                        child: TextFormField(
                          onSaved: (val) => email = val,
                          validator: (val) {
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val);
                            if (emailValid) {
                              return null;
                            } else
                              return "Invalid Email";
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                            ),
                            suffixIcon: Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20 * ScreenSize.heightMultiplyingFactor,
                            ),
                            labelText: "Email Address",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0 * ScreenSize.widthMultiplyingFactor,
                            vertical: 5.0 * ScreenSize.heightMultiplyingFactor),
                        child: TextFormField(
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          onSaved: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 8) {
                              return "Password must be of 8 character";
                            } else
                              return null;
                          },
                          obscureText: !showNormalPassword,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showNormalPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20 * ScreenSize.heightMultiplyingFactor,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  showNormalPassword = !showNormalPassword;
                                });
                              },
                            ),
                            labelText: "Password",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0 * ScreenSize.widthMultiplyingFactor,
                            vertical: 5.0 * ScreenSize.heightMultiplyingFactor),
                        child: TextFormField(
                          validator: (val) {
                            if (val == password) {
                              return null;
                            } else
                              return "Password does not match! Please Re-Write.";
                          },
                          obscureText: !showConfirmPassword,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20 * ScreenSize.heightMultiplyingFactor,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                            ),
                            labelText: "Confirm Password",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20 * ScreenSize.heightMultiplyingFactor,
                      ),
                      Container(
                        width: 234 * ScreenSize.widthMultiplyingFactor,
                        child: MaterialButton(
                          minWidth: 234 * ScreenSize.widthMultiplyingFactor,
                          height: 45 * ScreenSize.heightMultiplyingFactor,
                          color: primaryColour,
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              _formkey.currentState.save();
                              setState(() {
                                isLoading = true;
                              });
                              List<dynamic> check =
                                  await Authentication.createUser(
                                email.trim(),
                                password.trim(),
                                userName.trim(),
                                phoneNumber.trim(),
                              );
                              if (!check[0]) {
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(check[1]),
                                  duration: Duration(seconds: 3),
                                ));
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OnBoardingScreen()),
                                );
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                _autoValidate = true;
                              });
                            }
                          },
                          child: isLoading
                              ? Container(
                                  margin: EdgeInsets.all(3.0),
                                  height:
                                      25.0 * ScreenSize.widthMultiplyingFactor,
                                  width:
                                      25.0 * ScreenSize.widthMultiplyingFactor,
                                  child: circularProgressIndicator(
                                      col: Colors.white))
                              : Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        18 * ScreenSize.heightMultiplyingFactor,
                                  ),
                                ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10 * ScreenSize.heightMultiplyingFactor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: primaryColour,
                        fontFamily: "Poppins-Regular",
                        fontSize: 15 * ScreenSize.heightMultiplyingFactor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: primaryColour,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 15 * ScreenSize.heightMultiplyingFactor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
