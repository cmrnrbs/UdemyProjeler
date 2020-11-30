import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ornek/facebookuser.dart';
import 'package:firebase_ornek/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'googleuser.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleUser googleUser = new GoogleUser();
  FacebookUser facebookUser = new FacebookUser();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _login() async {
    await Firebase.initializeApp();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
        final profile = jsonDecode(graphResponse.body);
        setState(() {
          facebookUser.first_name = profile["first_name"];
          facebookUser.last_name = profile["last_name"];
          facebookUser.email = profile["email"];
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      facebookSignIn: facebookSignIn,
                      facebookUser: facebookUser,
                    )));

        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

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
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlutterLogo(
            size: 120,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Firebase Auth Example',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black54),
          ),
          SizedBox(
            height: 40,
          ),
          InkWell(
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
                        child: Text('Sign with Google'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              //loginWithFacebook();
              _login();
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
                          'assets/facebook.png',
                          width: 36,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      child: Center(
                        child: Text('Sign with Facebook'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
