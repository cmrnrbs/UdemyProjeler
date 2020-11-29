import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Example',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Custom Font',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
            ),
            Text(
              'Custom Font',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
