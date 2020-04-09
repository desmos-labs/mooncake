import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
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
  final GetPostDetailsUseCase _getPostDetailsUseCase;
  final GetCommentsUseCase _getCommentsUseCase;

  StreamSubscription _postSubscription;
  StreamSubscription _commentsSubscription;

  PostDetailsBloc({
    @required MooncakeAccount user,
    @required GetPostDetailsUseCase getPostDetailsUseCase,
    @required GetCommentsUseCase getCommentsUseCase,
  })  : assert(user != null),
        _user = user,
        assert(getPostDetailsUseCase != null),
        _getPostDetailsUseCase = getPostDetailsUseCase,
        assert(getCommentsUseCase != null),
        _getCommentsUseCase = getCommentsUseCase;

  factory PostDetailsBloc.create(BuildContext context) {
    return PostDetailsBloc(
      user: (BlocProvider.of<AccountBloc>(context).state as LoggedIn).user,
      getPostDetailsUseCase: Injector.get(),
      getCommentsUseCase: Injector.get(),
    );
  }

  @override
  PostDetailsState get initialState => LoadingPostDetails();

  @override
  Stream<PostDetailsState> mapEventToState(PostDetailsEvent event) async* {
    if (event is LoadPostDetails) {
      yield* _mapLoadPostEventToState(event);
    } else if (event is RefreshPostDetails) {
      yield* _mapRefreshEventToState();
    } else if (event is ShowTab) {
      yield* _mapShowTabEventToState(event);
    }
  }

  Stream<PostDetailsState> _mapLoadPostEventToState(
    LoadPostDetails event,
  ) async* {
    // TODO: Subscribe to the post events to notify about updates telling the user to refresh
    final post = await _getPostDetailsUseCase.fromRemote(event.postId);
    final comments = await _getCommentsUseCase.fromRemote(event.postId);
    yield PostDetailsLoaded.first(user: _user, post: post, comments: comments);
  }

  Stream<PostDetailsState> _mapRefreshEventToState() async* {
    final currentState = state;
    if (currentState is PostDetailsLoaded) {
      yield currentState.copyWith(refreshing: true);
      final postId = currentState.post.id;
      final post = await _getPostDetailsUseCase.fromRemote(postId);
      final comments = await _getCommentsUseCase.fromRemote(postId);
      yield currentState.copyWith(
        post: post,
        comments: comments,
        refreshing: false,
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
