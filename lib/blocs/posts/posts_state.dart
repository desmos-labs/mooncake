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

  const PostsLoaded([this.posts = const []]);

  @override
  List<Object> get props => [posts];

  @override
  String toString() => 'PostsLoaded { posts: $posts }';
}

class PostsNotLoaded extends PostsState {}
