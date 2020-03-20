import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the state of a single post item that is
/// present inside a posts list.
class PostListItemState extends Equatable {
  /// Account that is currently used from the user.
  final MooncakeAccount user;

  /// Tells whether or not the action bar is expanded.
  final bool actionBarExpanded;

  const PostListItemState({
    @required this.user,
    @required this.actionBarExpanded,
  });

  PostListItemState copyWith({
    MooncakeAccount user,
    Post post,
    bool actionBarExpanded,
  }) {
    return PostListItemState(
      user: user ?? this.user,
      actionBarExpanded: actionBarExpanded ?? this.actionBarExpanded,
    );
  }

  @override
  List<Object> get props => [user, actionBarExpanded];
}
