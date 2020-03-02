import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

abstract class PostListItemState extends Equatable {
  const PostListItemState();

  @override
  List<Object> get props => [];
}

class PostListItemLoading extends PostListItemState {
  @override
  String toString() => 'PostListItemLoading';
}

/// Represents the state of a single post item that is
/// present inside a posts list.
class PostListItemLoaded extends PostListItemState {
  /// Account that is currently used from the user.
  final User user;

  /// Post that is shown inside the item itself.
  final Post post;

  /// Tells whether or not the action bar is expanded.
  final bool actionBarExpanded;

  /// Tells whether the post has been liked from the user or not.
  bool get isLiked => hasUserReactedWith(Constants.LIKE_REACTION);

  /// Returns the number of likes that the post currently has.
  int get likesCount => post.reactions
      .where((reaction) => reaction.value == Constants.LIKE_REACTION)
      .length;

  /// Tells whether the button to show more options should be shown or not.
  bool get showMoreButton => post.reactions.length > 2;

  /// Tells whether the user has reacted with the given [reaction] or not.
  bool hasUserReactedWith(String reaction) => post.reactions.contains(Reaction(
        owner: user.accountData.address,
        value: reaction,
      ));

  const PostListItemLoaded({
    @required this.user,
    @required this.post,
    @required this.actionBarExpanded,
  });

  PostListItemLoaded copyWith({
    AccountData account,
    Post post,
    bool actionBarExpanded,
  }) {
    return PostListItemLoaded(
      user: account ?? this.user,
      post: post ?? this.post,
      actionBarExpanded: actionBarExpanded ?? this.actionBarExpanded,
    );
  }

  @override
  List<Object> get props => [user, post, actionBarExpanded];

  @override
  String toString() => 'PostListItemState {'
      'user: $user, '
      'post: $post, '
      'actionBarExpanded: $actionBarExpanded '
      '}';
}
