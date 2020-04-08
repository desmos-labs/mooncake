import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import './bloc.dart';

/// Represents the Bloc that should be used inside the screen that allows
/// to visualize the details of a single post.
class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final MooncakeAccount _user;

  StreamSubscription _postSubscription;
  StreamSubscription _commentsSubscription;

  PostDetailsBloc({
    @required MooncakeAccount user,
    @required String postId,
    @required GetPostDetailsUseCase getPostDetailsUseCase,
    @required GetCommentsUseCase getCommentsUseCase,
  })  : assert(user != null),
        _user = user,
        assert(getCommentsUseCase != null) {
    // TODO: Add the details event subscription to notify if new data
    // are created and prompt the user to refresh

    // Sub to the post details update
    _postSubscription = getPostDetailsUseCase.get(postId).listen((post) {
      add(ShowPostDetails(post: post));
    });

    // Sub to the comments update
    _commentsSubscription = getCommentsUseCase.get(postId).listen((comments) {
      add(ShowPostDetails(comments: comments));
    });
  }

  factory PostDetailsBloc.create(BuildContext context, String postId) {
    return PostDetailsBloc(
      user: (BlocProvider.of<AccountBloc>(context).state as LoggedIn).user,
      postId: postId,
      getPostDetailsUseCase: Injector.get(),
      getCommentsUseCase: Injector.get(),
    );
  }

  @override
  PostDetailsState get initialState => LoadingPostDetails();

  @override
  Stream<PostDetailsState> mapEventToState(PostDetailsEvent event) async* {
    if (event is ShowPostDetails) {
      yield* _mapShowPostDetailsEventToState(event);
    } else if (event is ShowTab) {
      yield* _mapShowTabEventToState(event);
    }
  }

  Stream<PostDetailsState> _mapShowPostDetailsEventToState(
    ShowPostDetails event,
  ) async* {
    final currentState = state;
    if (currentState is LoadingPostDetails) {
      yield PostDetailsLoaded.first(
        user: _user,
        post: event.post,
        comments: event.comments,
      );
    } else if (currentState is PostDetailsLoaded) {
      yield currentState.copyWith(
        post: event.post,
        comments: event.comments,
      );
    }
  }

  Stream<PostDetailsState> _mapShowTabEventToState(ShowTab event) async* {
    final currentState = state;
    if (currentState is PostDetailsLoaded) {
      yield currentState.copyWith(selectedTab: event.tab);
    }
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    _commentsSubscription?.cancel();
    return super.close();
  }
}
