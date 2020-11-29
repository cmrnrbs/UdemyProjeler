import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SharedPreferences',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter;

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt('counter') ?? 0) + 1;
    });
    print('Pressed $counter times.');
    await prefs.setInt('counter', counter);
  }

  getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter') ?? 0;
    });
  }

  //TODO: Hive Örnek

  Future<dynamic> _getValue(key) async {
    var box = await Hive.openBox('myBox');
    return box.get(key);
  }

  Future<void> _setValue(key, val) async {
    var box = await Hive.openBox('myBox');
    box.put(key, val);
  }

  Future<void> _initHive() async {
    await getApplicationDocumentsDirectory().then((value) {
      Hive.init(value.path);
    });
  }

  _incrementHiveCounter() async {
    _setValue("counter2", counter + 1).then((value) {
      setState(() {
        counter++;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    //getCounter();

    _initHive().then((value) {
      _getValue("counter2").then((value) {
        setState(() {
          counter = value ?? 0;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$counter'),
          FlatButton(
            onPressed: () => _incrementHiveCounter(),
            child: Text('Değeri Arttır ve Sakla'),
          ),
        ],
      )),
    );
  }
}
