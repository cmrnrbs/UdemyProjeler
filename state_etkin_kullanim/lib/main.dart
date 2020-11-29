import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'StateOrnek',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int degisken = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                activeColor: degisken == 1 ? Colors.blue : Colors.green,
              ),
              SizedBox(
                width: 10,
              ),
              CustomContainer(
                activeColor: degisken == 2 ? Colors.blue : Colors.green,
              ),
              SizedBox(
                width: 10,
              ),
              CustomContainer(
                activeColor: degisken == 3 ? Colors.blue : Colors.green,
              )
            ],
          ),
          FlatButton(
              onPressed: () {
                if (degisken == 3) {
                  setState(() {
                    degisken = 1;
                  });
                } else {
                  setState(() {
                    degisken++;
                  });
                }
              },
              child: Text('Değiştir'))
        ],
      )),
    );
  }
}

class CustomContainer extends StatelessWidget {
  Color activeColor;
  CustomContainer({this.activeColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: activeColor == Colors.blue
          ? Center(
              child: Text('Active'),
            )
          : SizedBox(),
      color: activeColor,
    );
  }
}
