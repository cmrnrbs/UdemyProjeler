import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Custom',
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
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
              clipper: MyCustomClipper(
                  deviceHeight: MediaQuery.of(context).size.height),
              child: Container(
                height: 300,
                color: Colors.blue,
              )),
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: 300,
              color: Colors.orange,
            ),
          )
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  double deviceHeight;
  MyCustomClipper({this.deviceHeight});
  @override
  Path getClip(Size size) {
    // path_1
    Path path = new Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width * .3, size.height - 20, size.width * .5, size.height - 120);

    path.quadraticBezierTo(
        size.width * .65, size.height - 180, size.width, size.height - 120);
    path.lineTo(size.width, size.height - 120);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
