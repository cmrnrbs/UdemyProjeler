import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'custom_dialog.dart';
import 'state_container.dart';
import 'user.dart';

void main() {
  runApp(new StateContainer(
    child: HomeApp(),
  ));
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inherited Sqflite',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future getData;

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);

    if (getData == null) {
      getData = container.getData();
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text('Inherited Sqflite Ornek'),
          actions: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialog(
                      user: new User(),
                      myscState: _scaffoldKey,
                    );
                  },
                );
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
              return Center(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                          child: ListTile(
                            title: Text(container.userList[index].name +
                                " " +
                                container.userList[index].surname),
                            subtitle: Text(container.userList[index].email),
                          ),
                        ),
                        actions: <Widget>[],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Update',
                            color: Colors.black45,
                            icon: Icons.more_horiz,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    user: container.userList[index],
                                    myscState: _scaffoldKey,
                                    buttonText: 'Güncelle',
                                  );
                                },
                              );
                            },
                          ),
                          IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                container
                                    .deleteUser(container.userList[index].id)
                                    .then((value) {
                                  setState(() {
                                    container.userList.removeWhere((element) =>
                                        element.id ==
                                        container.userList[index].id);
                                  });
                                });
                              }),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: container.userList.length),
              );
            }
          },
        ));
  }
}
