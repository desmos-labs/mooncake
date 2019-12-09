import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/dependency_injection/dependency_injection.dart';
import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/usecases/usecases.dart';
import 'package:meta/meta.dart';

import '../export.dart';

/// Implementation of [Bloc] that allows to properly deal with
/// events and states related to the list of posts.
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final int _syncPeriod;
  final CreatePostUseCase _createPostUseCase;
  final LikePostUseCase _likePostUseCase;
  final UnlikePostUseCase _unlikePostUseCase;
  final GetPostsUseCase _getPostsUseCase;
  final SyncPostsUseCase _syncPostsUseCase;

  Timer _syncTimer;
  StreamSubscription _postsSubscription;

  PostsBloc({
    @required int syncPeriod,
    @required CreatePostUseCase createPostUseCase,
    @required LikePostUseCase likePostUseCase,
    @required UnlikePostUseCase unlikePostUseCase,
    @required GetPostsUseCase getPostsUseCase,
    @required SyncPostsUseCase syncPostsUseCase,
  })  : _syncPeriod = syncPeriod,
        assert(createPostUseCase != null),
        _createPostUseCase = createPostUseCase,
        assert(likePostUseCase != null),
        _likePostUseCase = likePostUseCase,
        assert(unlikePostUseCase != null),
        _unlikePostUseCase = unlikePostUseCase,
        assert(getPostsUseCase != null),
        _getPostsUseCase = getPostsUseCase,
        assert(syncPostsUseCase != null),
        _syncPostsUseCase = syncPostsUseCase {
    print('Creting new post bloc');
  }

  factory PostsBloc.create({int syncPeriod = 20}) {
    return PostsBloc(
      syncPeriod: syncPeriod,
      createPostUseCase: Injector.get(),
      likePostUseCase: Injector.get(),
      unlikePostUseCase: Injector.get(),
      getPostsUseCase: Injector.get(),
      syncPostsUseCase: Injector.get(),
    );
  }

  @override
  PostsState get initialState => PostsLoading();

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    if (event is LoadPosts) {
      yield* _mapLoadPostsEventToState();
    } else if (event is AddPost) {
      yield* _mapAddPostEventToState(event);
    } else if (event is LikePost) {
      yield* _mapLikePostEventToState(event);
    } else if (event is UnlikePost) {
      yield* _mapUnlikePostEventToState(event);
    } else if (event is SyncPosts) {
      yield* _mapSyncPostsEventToState();
    }
  }

  Future<List<Post>> _getPosts() async {
    final posts = await _getPostsUseCase.get();
    posts.sort((p1, p2) => p2.compareTo(p1));
    return posts;
  }

  Stream<PostsState> _mapLoadPostsEventToState() async* {
    try {
      final posts = await _getPosts();
      yield PostsLoaded(posts: posts);

      // Observe for new posts
      if (_postsSubscription == null) {
        _postsSubscription = _getPostsUseCase.stream().listen((post) {
          add(LoadPosts());
        });
      }

      // Sync the activities of the user every 15 seconds
      if (_syncTimer?.isActive != true) {
        _syncTimer?.cancel();
        _syncTimer = Timer.periodic(Duration(seconds: _syncPeriod), (t) {
          add(SyncPosts());
        });
      }
    } catch (e) {
      print(e);
      yield PostsNotLoaded();
    }
  }

  Stream<PostsState> _mapAddPostEventToState(AddPost event) async* {
    if (state is PostsLoaded) {
      await _createPostUseCase.create(event.message, parentId: event.parentId);
      final updatedPosts = await _getPosts();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  Stream<PostsState> _mapLikePostEventToState(LikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await _likePostUseCase.like(event.postId);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  Stream<PostsState> _mapUnlikePostEventToState(UnlikePost event) async* {
    if (state is PostsLoaded) {
      final updatedPost = await _unlikePostUseCase.unlike(event.postId);
      final updatedPosts = (state as PostsLoaded)
          .posts
          .map((p) => p.id == updatedPost.id ? updatedPost : p)
          .toList();
      yield (state as PostsLoaded).copyWith(posts: updatedPosts);
    }
  }

  Stream<PostsState> _mapSyncPostsEventToState() async* {
    if (state is PostsLoaded) {
      yield (state as PostsLoaded).copyWith(showSnackbar: true);
      try {
        await _syncPostsUseCase.sync();
        final updatedPosts = await _getPosts();
        yield PostsLoaded(posts: updatedPosts);
      } catch (e) {
        print(e);
        yield (state as PostsLoaded).copyWith(showSnackbar: false);
      }
    }
  }

  @override
  Future<void> close() {
    print('Closing post bloc');
    _postsSubscription?.cancel();
    _syncTimer?.cancel();
    return super.close();
  }
}
