import 'package:desmosdemo/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;
  final bool showSnackbar;

  PostsLoaded({this.posts, this.showSnackbar = false});

  PostsLoaded copyWith({List<Post> posts, bool showSnackbar}) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      showSnackbar: showSnackbar ?? this.showSnackbar,
    );
  }

  @override
  List<Object> get props => [posts, showSnackbar];

  @override
  String toString() => 'PostsLoaded { '
      'posts: $posts, '
      'showSnackbar: $showSnackbar '
      '}';
}

class PostsNotLoaded extends PostsState {}
