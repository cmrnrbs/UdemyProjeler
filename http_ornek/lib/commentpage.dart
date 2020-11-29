import 'dart:convert';

import 'package:flutter/material.dart';
import 'comment.dart';
import 'package:http/http.dart' as http;

class CommentPage extends StatefulWidget {
  int postId;
  CommentPage({this.postId});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  Future getComments;

  Future<List<Comment>> fetchComments() async {
    List<Comment> results = new List<Comment>();

    final response = await http.get(
        "https://jsonplaceholder.typicode.com/posts/" +
            widget.postId.toString() +
            "/comments");

    if (response.statusCode == 200) {
      List listComment = jsonDecode(response.body);

      for (var i = 0; i < listComment.length; i++) {
        Comment item = Comment.fromJson(listComment[i]);
        results.add(item);
      }

      return results;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments = fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getComments,
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
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email +
                        '\n\n' +
                        snapshot.data[index].body),
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
