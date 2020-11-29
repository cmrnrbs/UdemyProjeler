import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Future Ornek',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int result;
  int foo() {
    return 42;
  }

  int bar(int value) {
    return value;
  }

  int Hesapla() {
    try {
      int value = foo();
      return bar(value);
    } catch (e) {
      return 499;
    }
  }

  Future Hesapla2() {
    
    try {
      int value = foo();
      // return bar(value);

      setState(() {
        result = bar(value);
      });
    } catch (e) {
      //return 499;
      setState(() {
        result = bar(499);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Hesapla2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('$result')),
    );
  }
}
