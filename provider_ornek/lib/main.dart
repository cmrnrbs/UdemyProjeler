import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:provider_ornek/sqlprocess.dart';
import 'package:provider_ornek/userprocess.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => SqlProcess()),
      ChangeNotifierProvider(create: (context) => UserProcess())
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sqflite',
      home: HomeScreen(),
    ),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState

    Provider.of<UserProcess>(context, listen: false).myScaffoldState =
        _scaffoldKey;

    Provider.of<UserProcess>(context, listen: false).getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProcess>(
      builder: (context, myuserprocess, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            title: Text('Sqflite Ornek'),
            actions: [
              InkWell(
                onTap: () {
                  Provider.of<SqlProcess>(context, listen: false)
                      .insertProcessDialog(context);
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
          body: ListView.separated(
              itemBuilder: (context, index) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    child: ListTile(
                      title: Text(myuserprocess.userList[index].name +
                          " " +
                          myuserprocess.userList[index].surname),
                      subtitle: Text(myuserprocess.userList[index].email),
                    ),
                  ),
                  actions: <Widget>[],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Update',
                      color: Colors.black45,
                      icon: Icons.more_horiz,
                      onTap: () {
                        Provider.of<SqlProcess>(context, listen: false)
                            .updateProcessDialog(
                                context, myuserprocess.userList[index]);
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () =>
                          Provider.of<UserProcess>(context, listen: false)
                              .deleteProcess(myuserprocess.userList[index].id,
                                  'Kayır Silindi'),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: myuserprocess.userList.length),
        );
      },
    );
  }
}
