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

/// Represents the Bloc that handles the state of a single post item
/// inside the posts list.
class PostListItemBloc extends Bloc<PostListItemEvent, PostListItemState> {
  PostListItemBloc();

  factory PostListItemBloc.create() {
    return PostListItemBloc();
  }

  @override
  PostListItemState get initialState {
    return PostListItemState(actionBarExpanded: false);
  }

  @override
  Stream<PostListItemState> mapEventToState(
    PostListItemEvent event,
  ) async* {
    if (event is ChangeReactionBarExpandedState) {
      yield state.copyWith(actionBarExpanded: !state.actionBarExpanded);
    }
  }
}
