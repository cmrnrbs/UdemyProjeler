import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_ornek/commentpage.dart';

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
  Future getdata;

  Future<List<Post>> fetchPost() async {
    List<Post> results = new List<Post>();

    final response =
        await http.get("https://jsonplaceholder.typicode.com/posts");

    if (response.statusCode == 200) {
      List listPost = jsonDecode(response.body);

      for (var i = 0; i < listPost.length; i++) {
        Post item = Post.fromJson(listPost[i]);
        results.add(item);
      }

      return results;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
          }
        },
      ),
    );
  }
}
