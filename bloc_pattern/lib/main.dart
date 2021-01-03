import 'package:bloc_pattern/blocs/post_bloc.dart';
import 'package:flutter/material.dart';
import 'commentpage.dart';

import 'post.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'HttpOrnek',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    post_bloc.fetchAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: post_bloc.allposts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentPage(
                                  postId: snapshot.data[index].id,
                                ))),
                    leading: Icon(Icons.local_post_office),
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].body),
                    trailing: Icon(Icons.read_more),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data.length);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else
              return Container(
                child: Center(
                  child: new Text(
                    'Something is wrong!',
                  ),
                ),
              );
          }),
    );
  }
}
