import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_ornek/advert_service.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'constraits.dart';
import 'facebookuser.dart';
import 'googleuser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'custom_dialog.dart';
import 'user.dart';

class HomeScreen extends StatefulWidget {
  GoogleUser googleUser;
  GoogleSignIn googleSignIn;
  FacebookLogin facebookSignIn;
  FacebookUser facebookUser;
  HomeScreen(
      {this.googleUser,
      this.googleSignIn,
      this.facebookSignIn,
      this.facebookUser});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AdvertService advertService = AdvertService();
  final _nativeAdController = NativeAdmobController();
  bool isLoaded = false;
  StreamSubscription _subscription;

  Future<void> signOutGoogle() async {
    await widget.googleSignIn.signOut();
    print("User Signed Out");
  }

  Future<Null> _logOut() async {
    await widget.facebookSignIn.logOut();
    print('Logged out.');
  }

  Future<List<User>> getData() async {
    final res = await FirebaseFirestore.instance.collection("users").get();

    List<User> myresults = new List<User>();
    for (int i = 0; i < res.docs.length; i++) {
      User user = new User(
          name: res.docs[i]["name"],
          surname: res.docs[i]["surname"],
          email: res.docs[i]["email"]);
      user.setDocumentID(res.docs[i].id);
      myresults.add(user);
    }

    return myresults;
  }

  insertProces() async {
    User res = await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          user: new User(),
        );
      },
    );

    await FirebaseFirestore.instance.collection("users").doc().set(res.toMap());

    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: Text('Kayıt Eklendi')));

    setState(() {});
  }

  updateProcess(documentID, User user) async {
    User res = await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          user: user,
        );
      },
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(documentID)
        .update(res.toMap());

    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: Text('Kayıt Güncellendi')));

    setState(() {});
  }

  deleteProcess(documentID) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(documentID)
        .delete();

    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: Text('Kayıt Silindi')));

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //advertService.bannerAd?.dispose();
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAdMob.instance.initialize(appId: ADMOB_APP_ID);
    //_subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    //advertService.showBanner();
    advertService.showInterstital();
    super.initState();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          isLoaded = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          isLoaded = true;
        });
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text('Firestore Ornek'),
          backgroundColor: Colors.grey,
          actions: [
            InkWell(
              onTap: () {
                insertProces();
              },
              child: Container(
                width: 50,
                height: 50,
                child: Center(
                  child: Icon(
                    Icons.group_add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            (widget.googleSignIn != null)
                ? InkWell(
                    onTap: () {
                      signOutGoogle().then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            widget.googleUser.imageUrl,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            (widget.facebookSignIn != null)
                ? InkWell(
                    onTap: () {
                      _logOut().then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
        body: Stack(
          children: [
            FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            child: ListTile(
                              title: Text(snapshot.data[index].name +
                                  " " +
                                  snapshot.data[index].surname),
                              subtitle: Text(snapshot.data[index].email),
                            ),
                          ),
                          actions: <Widget>[],
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Update',
                              color: Colors.black45,
                              icon: Icons.more_horiz,
                              onTap: () {
                                //updateProcess(snapshot.data[index]);
                                updateProcess(snapshot.data[index].documentID,
                                    snapshot.data[index]);
                              },
                            ),
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => deleteProcess(
                                  snapshot.data[index].documentID),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data.length);
                } else
                  return SizedBox();
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 330,
                color: Colors.white,
                child: isLoaded
                    ? NativeAdmob(
                        // Your ad unit id
                        adUnitID: NATIVE_AD_ID,
                        controller: _nativeAdController,
                        loading: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox(),
              ),
            )
          ],
        ));
  }
}
