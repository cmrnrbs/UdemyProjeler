import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_ornek/database_helper.dart';
import 'package:provider_ornek/user.dart';

class UserProcess extends ChangeNotifier {
  List<User> userList = [];
  GlobalKey<ScaffoldState> myScaffoldState = null;
  final DatabaseHelper databaseHelper = new DatabaseHelper();

  insertProcess(BuildContext context, User user, String text) async {
    Navigator.pop(context);
    await databaseHelper.insertUser(user).then((value) {
      userList.add(user);

      notifyListeners();
      myScaffoldState.currentState
          .showSnackBar(new SnackBar(content: new Text(text)));
    });
  }

  updateProcess(BuildContext context, User user, String text) async {
    Navigator.pop(context);
    await databaseHelper.update(user).then((value) {
      User olduser = userList.singleWhere((element) => element.id == user.id);
      olduser = user;

      notifyListeners();
      myScaffoldState.currentState
          .showSnackBar(new SnackBar(content: new Text(text)));
    });
  }

  deleteProcess(int id, String text) async {
    await databaseHelper.delete(id).then((value) {
      userList.removeWhere((element) => element.id == id);

      notifyListeners();
      myScaffoldState.currentState
          .showSnackBar(new SnackBar(content: new Text(text)));
    });
  }

  getData() async {
    await databaseHelper.getUsers().then((value) {
      userList = value;
      notifyListeners();
    });
  }
}
