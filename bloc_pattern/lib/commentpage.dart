import 'package:bloc_pattern/blocs/comment_bloc.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  int postId;
  CommentPage({this.postId});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  void initState() {
    // TODO: implement initState
    comment_bloc.fetchAllComments(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: comment_bloc.allcomments,
        builder: (context,  snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
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
            } else {
              return Center(
                child: Text("Bir hata meydana geldi"),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text("Bir hata meydana geldi"),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
