import 'package:appintro/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/appintro.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'AppIntro',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstRun = prefs.getBool('firstRun') ?? true;

    if (firstRun) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AppIntroScreen()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(new Duration(milliseconds: 2000), () {
      checkFirstRun();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      )),
    );
  }
}
