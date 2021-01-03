import 'package:bloc_pattern/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../comment.dart';

class CommentBloc {
  final repository = Repository();
  final commentFetcher = PublishSubject<List<Comment>>();
  Stream<List<Comment>> get allcomments => commentFetcher.stream;

  fetchAllComments(int id) async {
    List<Comment> list = await repository.fetchAllComments(id);
    commentFetcher.sink.add(list);
  }

  dispose(){
    commentFetcher.close();
  }
}

final comment_bloc = new CommentBloc();
