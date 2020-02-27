import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/blocs/export.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/entities/entities.dart';
import './bloc.dart';

/// Represents the BLoC that should be used inside the screen that allows
/// to visualize the details of a single post.
class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final GetCommentsUseCase _getPostCommentsUseCase;
  final PostsListBloc _postsListBloc;

  StreamSubscription _postsSubscription;

  PostDetailsBloc({
    @required GetCommentsUseCase getCommentsUseCase,
    @required PostsListBloc postsListBloc,
  })  : assert(getCommentsUseCase != null),
        this._getPostCommentsUseCase = getCommentsUseCase,
        assert(postsListBloc != null),
        this._postsListBloc = postsListBloc;

  factory PostDetailsBloc.create(BuildContext context, String postId) {
    return PostDetailsBloc(
        getCommentsUseCase: Injector.get(),
        postsListBloc: BlocProvider.of(context))
      ..add(LoadPostDetails(postId));
  }

  @override
  PostDetailsState get initialState => LoadingPostDetails();

  @override
  Stream<PostDetailsState> mapEventToState(PostDetailsEvent event) async* {
    if (event is LoadPostDetails) {
      yield* _mapLoadPostDetailsEventToState(event);
    } else if (event is ShowPostDetails) {
      yield* _mapShowPostDetailsEventToState(event);
    }
  }

  Stream<PostDetailsState> _mapLoadPostDetailsEventToState(
    LoadPostDetails event,
  ) async* {
    _postsSubscription = _postsListBloc.listen((state) async {
      final postsState = state;
      if (postsState is PostsLoaded) {
        // TODO: Probably remove this with a remote call instead?
        final post = postsState.posts.firstBy(id: event.postId);
        final comments = await _getPostCommentsUseCase.get(event.postId);
        add(ShowPostDetails(post: post, comments: comments));
      }
    });
  }

  Stream<PostDetailsState> _mapShowPostDetailsEventToState(
    ShowPostDetails event,
  ) async* {
    yield PostDetailsLoaded(post: event.post, comments: event.comments);
  }

  @override
  Future<Function> close() {
    _postsSubscription?.cancel();
  }
}
