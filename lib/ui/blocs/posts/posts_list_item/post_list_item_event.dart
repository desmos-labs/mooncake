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

/// Tells the Bloc to change the current state of the expanded reactions list.
class ChangeReactionBarExpandedState extends PostListItemEvent {
  ChangeReactionBarExpandedState();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ChangeReactionBarExpandedState';
}
