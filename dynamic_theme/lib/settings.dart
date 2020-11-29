import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  bool isDarkMode = false;
  Settings({this.isDarkMode});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool newDarkMode = false;
  setDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      newDarkMode = value;
    });
    await prefs.setBool("isDarkMode", value);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, newDarkMode);
        return Future(() => false);
      },
      child: Scaffold(
        body: Center(
          child: Switch(
              value: newDarkMode,
              onChanged: (value) => setDarkMode(value)),
        ),
      ),
    );
  }
}
