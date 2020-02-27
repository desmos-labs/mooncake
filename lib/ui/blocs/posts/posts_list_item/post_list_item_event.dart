import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic event that is emitted when interacting
/// with a single post.
abstract class PostListItemEvent extends Equatable {
  const PostListItemEvent();

  @override
  List<Object> get props => [];
}

/// Tells the BLoC that the data has been loaded.
class DataLoaded extends PostListItemEvent {
  final AccountData account;
  final Post post;

  DataLoaded({@required this.account, @required this.post});

  @override
  List<Object> get props => [account, post];

  @override
  String toString() => 'DataLoaded { account: $account, post: $post }';
}

/// Tells the BLoC that it needs to either set as liked/unliked the given post.
class AddOrRemoveLike extends PostListItemEvent {}

/// Tells the Bloc that it needs to either add (if not existing yet) or remove
/// (if existing) a reaction from the current user to the post.
class AddOrRemovePostReaction extends PostListItemEvent {
  final String reaction;

  AddOrRemovePostReaction({@required this.reaction});

  @override
  List<Object> get props => [reaction];

  @override
  String toString() => 'AddOrRemovePostReaction { reaction: $reaction }';
}

/// Tells the BLoC to change the current state of the expanded reactions list.
class ChangeReactionBarExpandedState extends PostListItemEvent {
  ChangeReactionBarExpandedState();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ChangeReactionBarExpandedState';
}
