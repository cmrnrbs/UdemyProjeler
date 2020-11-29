import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hero_animation/detailpage.dart';
import 'package:http/http.dart' as http;

import 'photos.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'HttpOrnek',
    home: ContentScreen(),
  ));
}

class ContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen(mycontext: context);
  }
}

class HomeScreen extends StatefulWidget {
  BuildContext mycontext;
  HomeScreen({this.mycontext});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController _animationController, _animationControllerColor;
  Animation<double> _animation;
  Animation<Color> _animationColor;
  Future getdata;
  bool isOpen = false;

  Future<List<Photos>> fetchPost() async {
    List<Photos> results = new List<Photos>();

    final response =
        await http.get("https://jsonplaceholder.typicode.com/photos");

    if (response.statusCode == 200) {
      List listPost = jsonDecode(response.body);

      for (var i = 0; i < listPost.length; i++) {
        Photos item = Photos.fromJson(listPost[i]);
        results.add(item);
      }

      return results;
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _animationControllerColor = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _animationColor = ColorTween(begin: Colors.green, end: Colors.blue)
        .animate(_animationControllerColor)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {}
          });

    _animation = Tween<double>(
            begin: 0, end: MediaQuery.of(widget.mycontext).size.height)
        .animate(_animationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                isOpen = true;
              });
            } else if (status == AnimationStatus.reverse) {
              setState(() {
                isOpen = false;
              });
            }
          });
    super.initState();
    getdata = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isOpen
          ? FloatingActionButton(
              onPressed: () {
                //_animationController.forward();
                if (!isOpen) {
                  setState(() {
                    isOpen = true;
                  });
                }
              },
              child: Center(
                child: Icon(Icons.menu),
              ),
            )
          : SizedBox(),
      body: Stack(
        children: [
          FutureBuilder(
            future: getdata,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Text('Bir hata meydana geldi'),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                //var d = jsonDecode(snapshot.data.body);
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                      myphoto: snapshot.data[index],
                                    ))),
                        leading: Hero(
                            tag: snapshot.data[index].id.toString(),
                            child: Image.network(snapshot.data[index].url)),
                        title: Text(snapshot.data[index].title),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data.length);
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _animation.value,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          _animationController.reverse();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: isOpen
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  color: _animationColor.value,
                                ),
                                FlatButton(
                                  onPressed: () {
                                    _animationControllerColor.forward();
                                  },
                                  child: Text('Color animation'),
                                ),
                              ],
                            )
                          : SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              color: Colors.white,
              height: !isOpen ? 0 : MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isOpen = false;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: isOpen
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  color: _animationColor.value,
                                ),
                                FlatButton(
                                  onPressed: () {
                                    _animationControllerColor.forward();
                                  },
                                  child: Text('Color animation'),
                                ),
                              ],
                            )
                          : SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
