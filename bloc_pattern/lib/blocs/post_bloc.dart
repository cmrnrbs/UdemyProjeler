import 'package:bloc_pattern/repository.dart';

import 'package:rxdart/rxdart.dart';

import '../post.dart';

class PostBloc {
  final repository = Repository();
  final postFetcher = PublishSubject<List<Post>>();
  Stream<List<Post>> get allposts => postFetcher.stream;

  fetchAllPosts() async {
    List<Post> list = await repository.fetchAllPosts();
    postFetcher.sink.add(list);
  }

  dispose() {
    postFetcher.close();
  }
}

final post_bloc = new PostBloc();
