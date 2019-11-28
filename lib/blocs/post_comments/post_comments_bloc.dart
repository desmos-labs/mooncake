import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/repositories/posts_repository.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

/// [Bloc] instance that allows to properly deal with post comments.
class PostCommentsBloc extends Bloc<PostCommentsEvent, PostCommentsState> {
  final PostsRepository repository;

  /// [PostsBloc] that is used in order to observe for new [PostsLoaded]
  /// states so that each time a new post is created the refresh the
  /// comments list.
  final PostsBloc postsBloc;
  StreamSubscription _subscription;

  PostCommentsBloc({@required this.repository, @required this.postsBloc}) {
    _subscription = postsBloc.listen((state) {
      if (state is PostsLoaded) {
        add(RefreshComments());
      }
    });
  }

  @override
  PostCommentsState get initialState => PostCommentsLoading();

  @override
  Stream<PostCommentsState> mapEventToState(PostCommentsEvent event) async* {
    if (event is LoadPostComments) {
      yield* _mapLoadPostCommentsEventToState(event);
    } else if (event is RefreshComments) {
      yield* _mapRefreshCommentsEventToState(event);
    }
  }

  Stream<PostCommentsState> _mapLoadPostCommentsEventToState(
    LoadPostComments event,
  ) async* {
    final comments = await repository.getCommentsForPost(event.postId);
    yield PostCommentsLoaded(postId: event.postId, comments: comments);
  }

  Stream<PostCommentsState> _mapRefreshCommentsEventToState(
    RefreshComments event,
  ) async* {
    if (state is PostCommentsLoaded) {
      add(LoadPostComments((state as PostCommentsLoaded).postId));
    }
  }

  /// Overridden close method in order to properly cancel the
  /// [_subscription] we have with the posts bloc.
  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
