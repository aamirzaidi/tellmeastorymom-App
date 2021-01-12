import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User> get firebaseUser {
    return _auth.authStateChanges();
  }

  Future<List<dynamic>> signInWithGoogle() async {
    bool returnData = false;
    bool foundError = false;
    String errorMessage = "";
    bool isSelected = false;
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      print(googleUser);
      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        print(googleAuth);

        // Create a new credential
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        print(credential);
        User user = (await _auth.signInWithCredential(credential)).user;
        await firebaseFirestore.collection('Users').get().then((value) {
          value.docs.forEach((element) {
            element.data().forEach((key, value) {
              print("Key: " + key.toString());
              print("Value: " + value.toString());
              if (key.toString() == "email" && value.toString() == user.email) {
                print("HELLO USER MATCHED");
                returnData = true;
              }
            });
          });
        });
        print(user.providerData);
        print(returnData);
      } else {
        isSelected = true;
      }
    } catch (e) {
      foundError = true;
      print(e);
      errorMessage = e.message;
    }
    // Once signed in, return the UserCredential
    return [
      returnData,
      foundError,
      errorMessage,
      isSelected,
    ];
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}
