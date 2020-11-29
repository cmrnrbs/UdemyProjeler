import 'package:dynamic_theme/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Home',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;

  Future checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });

    return isDarkMode;
  }

  pageNav() async {
    final ret = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Settings(
                  isDarkMode: isDarkMode,
                )));

    setState(() {
      isDarkMode = ret;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 100,
              height: 40,
              color: !isDarkMode ? Colors.blue : Colors.red,
              child: Center(
                child: Text('Tıkla'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: InkWell(
                onTap: () {
                  pageNav();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Icon(Icons.settings),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
