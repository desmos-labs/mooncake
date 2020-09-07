import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import 'export.dart';

/// Represents the Bloc that should be used inside the screen that allows
/// to visualize the details of a single post.
class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final MooncakeAccount _user;

  // Usecases
  final GetPostDetailsUseCase _getPostDetailsUseCase;
  final GetCommentsUseCase _getCommentsUseCase;

  // Subscriptions
  StreamSubscription _postSubscription;
  StreamSubscription _commentsSubscription;

  PostDetailsBloc({
    @required MooncakeAccount user,
    @required String postId,
    @required GetPostDetailsUseCase getPostDetailsUseCase,
    @required GetCommentsUseCase getCommentsUseCase,
  })  : assert(postId != null),
        assert(user != null),
        _user = user,
        assert(getPostDetailsUseCase != null),
        _getPostDetailsUseCase = getPostDetailsUseCase,
        assert(getCommentsUseCase != null),
        _getCommentsUseCase = getCommentsUseCase,
        super(LoadingPostDetails()) {
    add(LoadPostDetails(postId));

    _postSubscription = getPostDetailsUseCase.stream(postId).listen((post) {
      add(PostDetailsUpdated(post));
    });

    _commentsSubscription = getCommentsUseCase.stream(postId).listen((posts) {
      add(PostCommentsUpdated(posts));
    });
  }

  factory PostDetailsBloc.create(BuildContext context, String postId) {
    return PostDetailsBloc(
      postId: postId,
      user: (BlocProvider.of<AccountBloc>(context).state as LoggedIn).user,
      getPostDetailsUseCase: Injector.get(),
      getCommentsUseCase: Injector.get(),
    );
  }

  @override
  Stream<PostDetailsState> mapEventToState(PostDetailsEvent event) async* {
    if (event is ShowTab) {
      yield* _mapShowTabEventToState(event);
    } else if (event is LoadPostDetails) {
      yield* _mapLoadPostEventToState(event);
    } else if (event is PostDetailsUpdated) {
      yield* _mapPostDetailsUpdatedToState(event);
    } else if (event is PostCommentsUpdated) {
      yield* _mapPostCommentsUpdateToState(event);
    }
  }

  Stream<PostDetailsState> _mapShowTabEventToState(ShowTab event) async* {
    final currentState = state;
    if (currentState is PostDetailsLoaded) {
      yield currentState.copyWith(selectedTab: event.tab);
    }
  }

  Stream<PostDetailsState> _mapLoadPostEventToState(
    LoadPostDetails event,
  ) async* {
    final post = await _getPostDetailsUseCase.fromRemote(event.postId);
    final comments = await _getCommentsUseCase.fromRemote(event.postId);
    yield PostDetailsLoaded.first(
      user: _user,
      post: post,
      comments: comments,
    );
  }

  Stream<PostDetailsState> _mapPostDetailsUpdatedToState(
    PostDetailsUpdated event,
  ) async* {
    final currentState = state;
    if (currentState is PostDetailsLoaded) {
      yield currentState.copyWith(
        post: event.post,
        refreshing: false,
      );
    }
  }

  Stream<PostDetailsState> _mapPostCommentsUpdateToState(
    PostCommentsUpdated event,
  ) async* {
    final currentState = state;
    if (currentState is PostDetailsLoaded) {
      yield currentState.copyWith(
        comments: event.comments,
      );
    }
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    _commentsSubscription?.cancel();
    return super.close();
  }
}
