import 'package:flutter/material.dart';
import 'package:inheritedwidget_ornek/user.dart';

import 'database_helper.dart';


class InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;
  InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final List<User> userList;

  StateContainer({@required this.child, this.userList});

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedStateContainer)
            as InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  List<User> userList;

  Future<List<User>> getData() async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    await databaseHelper.getUsers().then((value) async {
      setState(() {
        userList = value;
      });

      return userList;
    });
  }

  Future addUser(User user) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    if (userList == null) {
      await databaseHelper.getUsers().then((value) async {
        setState(() {
          userList = value;
        });

        await databaseHelper.insertUser(user).then((value) {
          setState(() {
            userList.add(user);
          });
        });
      });
    } else {
      await databaseHelper.insertUser(user).then((value) {
        setState(() {
          userList.add(user);
        });
      });
    }
  }

  Future updateUser(User user) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    if (userList == null) {
      await databaseHelper.getUsers().then((value) async {
        setState(() {
          userList = value;
        });
        await databaseHelper.update(user).then((value) {
          setState(() {
            User currentUser =
                userList.singleWhere((element) => element.id == user.id);
            if (currentUser != null) {
              setState(() {
                currentUser = user;
              });
            }
          });
        });
      });
    } else {
      await databaseHelper.update(user).then((value) {
        setState(() {
          User currentUser =
              userList.singleWhere((element) => element.id == user.id);
          if (currentUser != null) {
            setState(() {
              currentUser = user;
            });
          }
        });
      });
    }
  }

  Future deleteUser(int id) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    if (userList == null) {
      await databaseHelper.getUsers().then((value) async {
        setState(() {
          userList = value;
        });
        await databaseHelper.delete(id).then((value) {
          setState(() {
            userList.removeWhere((element) => element.id == id);
          });
        });
      });
    } else {
      await databaseHelper.delete(id).then((value) {
        setState(() {
          userList.removeWhere((element) => element.id == id);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
