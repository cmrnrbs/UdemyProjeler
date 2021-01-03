import 'dart:convert';

import 'comment.dart';
import 'post.dart';
import 'package:http/http.dart' as http;

class Repository {
  
  Future<List<Post>> fetchAllPosts() async {
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

  Future<List<Comment>> fetchAllComments(int id) async {
    List<Comment> results = new List<Comment>();

    final response = await http.get(
        "https://jsonplaceholder.typicode.com/posts/" +
            id.toString() +
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
}
