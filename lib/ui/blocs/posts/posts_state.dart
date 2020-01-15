import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:equatable/equatable.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final String address;
  final List<Post> posts;

  final bool syncingPosts;
  final bool fetchingPosts;

  PostsLoaded({
    @required this.address,
    @required this.posts,
    this.syncingPosts = false,
    this.fetchingPosts = false,
  });

  PostsLoaded copyWith({
    int page,
    String address,
    List<Post> posts,
    bool isLoadingNewPage,
    bool hasReachedMax,
    bool syncingPosts,
    bool fetchingPosts,
  }) {
    return PostsLoaded(
      address: address ?? this.address,
      posts: posts ?? this.posts,
      syncingPosts: syncingPosts ?? this.syncingPosts,
      fetchingPosts: fetchingPosts ?? this.fetchingPosts,
    );
  }

  @override
  List<Object> get props => [
        posts,
        syncingPosts,
        fetchingPosts,
      ];

  @override
  String toString() => 'PostsLoaded { '
      'posts: ${posts.length}, '
      'syncingPosts: $syncingPosts, '
      'fetchingPosts: $fetchingPosts '
      '}';
}

class PostsNotLoaded extends PostsState {}
