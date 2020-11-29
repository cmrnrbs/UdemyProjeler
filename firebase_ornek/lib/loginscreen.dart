import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ornek/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'googleuser.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleUser googleUser = new GoogleUser();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<GoogleUser> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User user = authResult.user;

    if (user != null) {
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      setState(() {
        googleUser.name = user.displayName;
        googleUser.email = user.email;
        googleUser.imageUrl = user.photoURL;
      });

      if (googleUser.name.contains(" ")) {
        googleUser.name =
            googleUser.name.substring(0, googleUser.name.indexOf(" "));
      }

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return googleUser;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: () {
          signInWithGoogle().then((result) {
            if (result != null) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return HomeScreen(
                    googleUser: result,
                    googleSignIn: googleSignIn,
                  );
                },
              ));
            }
          });
        },
        child: Material(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(.5),
          child: Container(
            width: 240,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 36,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 150,
                  child: Center(
                    child: Text('Google Sign'),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
