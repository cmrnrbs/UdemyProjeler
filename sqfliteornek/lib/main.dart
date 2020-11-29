import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqfliteornek/custom_dialog.dart';
import 'package:sqfliteornek/database_helper.dart';

import 'user.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Sqflite',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseHelper databaseHelper;
  Future getData;

  insertProcess() async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          user: new User(),
        );
      },
    );

    if (res != null) {
      databaseHelper.insertUser(res).then((value) {
        afterProccess('Kayıt Başarılı');
      });
    }
  }

  updateProcess(User user) async {
    final res = await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          user: user,
          buttonText: 'Güncelle',
        );
      },
    );

    if (res != null) {
      databaseHelper.update(user).then((value) {
        afterProccess('Kayıt Güncellendi');
      });
    }
  }

  deleteProcess(int id) async {
    databaseHelper.delete(id).then((value) {
      afterProccess('Kayıt Silindi');
    });
  }

  afterProccess(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));

    setState(() {
      getData = databaseHelper.getUsers();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseHelper = new DatabaseHelper();

    getData = databaseHelper.getUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Sqflite Ornek'),
        actions: [
          InkWell(
            onTap: () {
              insertProcess();
            },
            child: Container(
              width: 50,
              height: 50,
              child: Center(
                child: Icon(Icons.group_add),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text('Veritabanına erişilemedi'),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      child: ListTile(
                        title: Text(snapshot.data[index].name +
                            " " +
                            snapshot.data[index].surname),
                        subtitle: Text(snapshot.data[index].email),
                      ),
                    ),
                    actions: <Widget>[],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Update',
                        color: Colors.black45,
                        icon: Icons.more_horiz,
                        onTap: () {
                          updateProcess(snapshot.data[index]);
                        },
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => deleteProcess(snapshot.data[index].id),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data.length);
          }
        },
      ),
    );
  }
}
