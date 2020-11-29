import 'package:flutter/material.dart';
import 'package:splashscreen/detailpage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  yonlendir() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailPage()));
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(new Duration(seconds: 3), () {
      yonlendir();
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
          child: Center(
            child: Icon(
              Icons.home,
              size: 60,
              color: Colors.white,
            ),
          ),
          decoration:
              BoxDecoration(color: Colors.yellow[700], shape: BoxShape.circle),
        ),
      ),
    );
  }
}
