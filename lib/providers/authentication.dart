import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Authentication {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User currentUser;
  static UserCredential userCredentials;
  static Future<List<dynamic>> createUser(
      String email, String password, String name, String phoneNumber) async {
    try {
      userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      currentUser = userCredentials.user;
      _firebaseFirestore.collection('Users').doc(currentUser.uid).set({
        'email': email,
        'displayName': name,
        'phoneNumber': phoneNumber,
      });
      if (currentUser != null) {
        return [true, ""];
      }
    } catch (e) {
      return [false, e.message];
    }
    return [
      false,
      "Something Went Wrong, Please try again later or restart the application! ✌"
    ];
  }

  static Future<List<dynamic>> checkUser(String email, String password) async {
    try {
      userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredentials != null) {
        return [true, ""];
      }
    } on PlatformException catch (e) {
      print(e.message);
      return [false, e.message];
    } catch (e) {
      print(e.message);
      return [false, e.message];
    }
    return [
      false,
      "Something Went Wrong, Please try again later or restart the application! ✌"
    ];
  }
}
