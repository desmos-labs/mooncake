import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state of a single post item that is
/// present inside a posts list.
class PostListItemState extends Equatable {
  /// Tells whether or not the action bar is expanded.
  final bool actionBarExpanded;

  const PostListItemState({
    @required this.actionBarExpanded,
  });

  PostListItemState copyWith({
    bool actionBarExpanded,
  }) {
    return PostListItemState(
      actionBarExpanded: actionBarExpanded ?? this.actionBarExpanded,
    );
  }

  @override
  List<Object> get props => [actionBarExpanded];
}
