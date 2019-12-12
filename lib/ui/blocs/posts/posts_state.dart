import 'package:dwitter/entities/entities.dart';
import 'package:equatable/equatable.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final int page;
  final List<Post> posts;

  final bool isLoadingNewPage;
  final bool hasReachedMax;
  final bool syncingPosts;
  final bool fetchingPosts;

  PostsLoaded({
    this.page,
    this.posts,
    this.isLoadingNewPage = false,
    this.hasReachedMax = false,
    this.syncingPosts = false,
    this.fetchingPosts = false,
  });

  PostsLoaded copyWith({
    int page,
    List<Post> posts,
    bool isLoadingNewPage,
    bool hasReachedMax,
    bool syncingPosts,
    bool fetchingPosts,
  }) {
    return PostsLoaded(
      page: page ?? this.page,
      posts: posts ?? this.posts,
      isLoadingNewPage: isLoadingNewPage ?? this.isLoadingNewPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      syncingPosts: syncingPosts ?? this.syncingPosts,
      fetchingPosts: fetchingPosts ?? this.fetchingPosts,
    );
  }

  @override
  List<Object> get props => [
        page,
        posts,
        hasReachedMax,
        isLoadingNewPage,
        syncingPosts,
        fetchingPosts,
      ];

  @override
  String toString() => 'PostsLoaded { '
      'page: $page, '
      'posts: ${posts.length}, '
      'isLoadingNewPage: $isLoadingNewPage, '
      'hasReachedMax: $hasReachedMax, '
      'syncingPosts: $syncingPosts, '
      'fetchingPosts: $fetchingPosts '
      '}';
}

class PostsNotLoaded extends PostsState {}
