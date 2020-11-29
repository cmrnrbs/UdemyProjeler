import 'package:flutter/material.dart';
import 'package:splash_screen/splashscreen.dart';

void main() {
  runApp(MaterialApp(
    title: 'SplashScreen',
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
