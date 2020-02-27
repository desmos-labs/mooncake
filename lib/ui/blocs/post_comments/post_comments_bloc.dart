import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/usecases/posts/posts.dart';

import '../export.dart';

/// [Bloc] instance that allows to properly deal with post comments.
class PostCommentsBloc extends Bloc<PostCommentsEvent, PostCommentsState> {
  final GetCommentsUseCase _commentsUseCase;

  StreamSubscription _subscription;

  PostCommentsBloc({
    @required GetCommentsUseCase getCommentsUseCase,
    @required PostsListBloc PostsListBloc,
  })  : assert(getCommentsUseCase != null),
        assert(PostsListBloc != null),
        _commentsUseCase = getCommentsUseCase {
    // Start listening for new posts so that we can update the
    // comments accordingly
    _subscription = PostsListBloc.listen((state) {
      if (state is PostsLoaded) {
        add(RefreshComments());
      }
    });
  }

  factory PostCommentsBloc.create(BuildContext context) {
    return PostCommentsBloc(
      PostsListBloc: BlocProvider.of(context),
      getCommentsUseCase: Injector.get(),
    );
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
    final comments = await _commentsUseCase.get(event.postId);
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
