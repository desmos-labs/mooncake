import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/repositories/repositories.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Implementation of [PostsRepository].
class PostsRepositoryImpl extends PostsRepository {
  final LocalPostsSource _localPostsSource;
  final RemotePostsSource _remotePostsSource;

  PostsRepositoryImpl({
    @required LocalPostsSource localSource,
    @required RemotePostsSource remoteSource,
  })  : assert(localSource != null),
        _localPostsSource = localSource,
        assert(remoteSource != null),
        _remotePostsSource = remoteSource {
    // Initialize the events update
    _remotePostsSource
        .getEventsStream()
        .asyncMap((event) {
          if (event is PostCreatedEvent) {
            return _mapPostCreatedEventToPosts(event);
          } else if (event is PostEvent) {
            return _mapPostEventToPosts(event);
          } else {
            return [];
          }
        })
        .expand((posts) => posts as List<Post>)
        .where((p) => p.subspace == Constants.SUBSPACE)
        .listen((post) async {
          _localPostsSource.savePost(post, emit: true);
        });
  }

  /// Transforms the given [event] to the list of posts to be updated.
  Future<List<Post>> _mapPostCreatedEventToPosts(PostCreatedEvent event) async {
    final posts = List<Post>();
    final post = await _remotePostsSource.getPostById(event.postId);

    if (post != null) {
      posts.add(post);
    }

    // Emit the updated parent
    if (post?.hasParent == true) {
      final parent = await _remotePostsSource.getPostById(post.parentId);
      if (parent != null) {
        posts.add(parent);
      }
    }

    return posts;
  }

  /// Maps the given [event] to the list of posts that should be updated.
  Future<List<Post>> _mapPostEventToPosts(PostEvent event) async {
    final posts = List<Post>();

    final post = await _remotePostsSource.getPostById(event.postId);
    if (post != null) {
      posts.add(post);
    }

    return posts;
  }

  @override
  Future<Post> getPostById(String postId) async {
    return Post(
      parentId: "0",
      id: "0",
      created: "2020-24-02T08:40:00.000Z",
      owner: User(
        username: "Desmos",
        address: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
        avatarUrl:
        "https://pbs.twimg.com/profile_images/1206578012549980162/6L485PKE_400x400.jpg",
      ),
      subspace: Constants.SUBSPACE,
      allowsComments: true,
      optionalData: {},
      status: PostStatus(value: PostStatusValue.SYNCED),
      lastEdited: null,
      message:
      "Social networking is such a massive part of our lives. From today we are giving complete power to the users",
      medias: [
        PostMedia(
          mimeType: "image/jpeg",
          url:
          "https://pbs.twimg.com/media/EMO5gOEWkAArAU1?format=jpg&name=4096x4096",
        ),
      ],
      reactions: [
        Reaction(
          owner: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
          value: "👍",
        ),
        Reaction(
          owner: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          value: "😃",
        ),
        Reaction(
          owner: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          value: "😁",
        )
      ],
      commentsIds: [],
    );

    // TODO: Implement this again
    return _localPostsSource.getPostById(postId);
  }

  @override
  Future<List<Post>> getPostComments(String postId) async {
    return [];


    // TODO: Implement this again
    final comments = await _remotePostsSource.getPostComments(postId);
    comments.forEach((comment) async {
      await _localPostsSource.savePost(comment, emit: false);
    });

    return _localPostsSource.getPostComments(postId);
  }

  @override
  Future<List<Post>> getPosts({bool forceOnline = false}) async {
    // TODO: Remove this
    return [
      Post(
        parentId: "0",
        id: "0",
        created: "2020-24-02T08:40:00.000Z",
        owner: User(
          username: "Desmos",
          address: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
          avatarUrl:
              "https://pbs.twimg.com/profile_images/1206578012549980162/6L485PKE_400x400.jpg",
        ),
        subspace: Constants.SUBSPACE,
        allowsComments: true,
        optionalData: {},
        status: PostStatus(value: PostStatusValue.SYNCED),
        lastEdited: null,
        message:
            "Social networking is such a massive part of our lives. From today we are giving complete power to the users",
        medias: [
          PostMedia(
            mimeType: "image/jpeg",
            url:
                "https://pbs.twimg.com/media/EMO5gOEWkAArAU1?format=jpg&name=4096x4096",
          ),
        ],
        reactions: [
          Reaction(
            owner: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
            value: "👍",
          ),
          Reaction(
            owner: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
            value: "😃",
          ),
          Reaction(
            owner: "desmos1hm422rugs829rmvrge35dea05sce86z2qf0mrc",
            value: "😁",
          )
        ],
        commentsIds: [],
      ),
      Post(
        parentId: "0",
        id: "1",
        created: "2020-24-02T09:00:00.000Z",
        owner: User(
            username: "Alice Jackson",
            address: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
            avatarUrl:
                "https://image.made-in-china.com/2f0j00AmtTrcdLyJoj/Wholesale-Plastic-Polarized-Custom-Women-Sunglasses.jpg"),
        subspace: Constants.SUBSPACE,
        allowsComments: true,
        optionalData: {},
        status: PostStatus(value: PostStatusValue.SYNCED),
        lastEdited: null,
        message: "Aliquam non sem nulla. In nulla mauris, imperdiet in ex in, egestas eleifend tellus. Curabitur facilisis mi nibh, sit amet luctus augue fermentum a.",
        medias: [
          PostMedia(
            mimeType: "image/jpeg",
            url: "https://www.plannthat.com/wp-content/uploads/2017/10/brahmino.png",
          ),
          PostMedia(
            mimeType: "image/jpeg",
            url: "https://cdn.hiconsumption.com/wp-content/uploads/2017/03/best-adventure-instagram-accounts-1087x725.jpg",
          ),
          PostMedia(
            mimeType: "image/jpeg",
            url: "https://kelseyinlondon.com/wp-content/uploads/2019/02/1-kelseyinlondon_kelsey_heinrichs_Paris-The-20-Best-Instagram-Photography-Locations.jpg",
          ),
          PostMedia(
            mimeType: "image/jpeg",
            url: "https://static2.businessinsider.com/image/546baf3069bedd6b6936ca04/the-best-instagram-accounts-to-follow.jpg",
          ),
        ],
        reactions: [
          Reaction(
            owner: "desmos12v62d963xs2sqfugdtrg4a8myekvj3sf473cfv",
            value: ":+1:",
          )
        ],
        commentsIds: [],
      ),
    ];

//    if (forceOnline) {
//      final posts = await _remotePostsSource.getPosts();
//      await _localPostsSource.savePosts(posts, emit: false);
//    }
//
//    return _localPostsSource.getPosts();
  }

  @override
  Future<List<Post>> getPostsToSync() => _localPostsSource.getPostsToSync();

  @override
  Stream<Post> get postsStream => _localPostsSource.postsStream;

  @override
  Future<void> savePost(Post post) async {
    // Save the post
    await _localPostsSource.savePost(post);

    // Update the parent comments if the parent exists and does not contain
    // the post id as a comment yet
    Post parent = await _localPostsSource.getPostById(post.parentId);
    if (parent != null && !parent.commentsIds.contains(post.id)) {
      parent = parent.copyWith(commentsIds: [post.id] + parent.commentsIds);
      await _localPostsSource.savePost(parent);
    }
  }

  @override
  Future<void> syncPosts(List<Post> posts) =>
      _remotePostsSource.savePosts(posts);

  @override
  Future<void> deletePost(String postId) =>
      _localPostsSource.deletePost(postId);
}
