import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'post_notifications.g.dart';

/// Represents a basic notification that represents an interaction with a post.
abstract class BasePostInteractionNotification extends NotificationData {
  /// Represents the ID of post towards which this notification is directed.
  @JsonKey(name: "post_id", nullable: false)
  final String postId;

  /// Represents the user that has interacted with the post.
  @JsonKey(name: "user", nullable: false)
  final User user;

  BasePostInteractionNotification({
    @required String type,
    @required DateTime date,
    String action,
    String title,
    String body,
    @required this.postId,
    @required this.user,
  })  : assert(postId != null),
        assert(user != null),
        super(
          type: type,
          action: action,
          date: date,
          title: title,
          body: body,
        );

  @override
  List<Object> get props => super.props + [postId, user];
}

/// Represents a notification telling that a comment has been added to
/// a post that was previously created from the user.
@immutable
@JsonSerializable(explicitToJson: true)
class PostCommentNotification extends BasePostInteractionNotification {
  /// Represents the comment message.
  @JsonKey(name: "message")
  final String comment;

  PostCommentNotification({
    @required String postId,
    @required User user,
    @required this.comment,
    @required DateTime date,
    String title,
    String body,
  })  : assert(comment != null),
        super(
          type: NotificationTypes.COMMENT,
          action: NotificationActions.ACTION_SHOW_POST,
          date: date,
          postId: postId,
          user: user,
          title: title,
          body: body,
        );

  @override
  List<Object> get props => super.props + [];

  factory PostCommentNotification.fromJson(Map<String, dynamic> json) =>
      _$PostCommentNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostCommentNotificationToJson(this);
}

/// Represents a notification telling that a like has been added
/// to a post previously created from the user.
@immutable
@JsonSerializable(explicitToJson: true)
class PostLikeNotification extends BasePostInteractionNotification {
  PostLikeNotification({
    @required String postId,
    @required User user,
    @required DateTime date,
    String title,
    String body,
  }) : super(
          type: NotificationTypes.LIKE,
          action: NotificationActions.ACTION_SHOW_POST,
          date: date,
          postId: postId,
          user: user,
          title: title,
          body: body,
        );

  factory PostLikeNotification.fromJson(Map<String, dynamic> json) =>
      _$PostLikeNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostLikeNotificationToJson(this);
}

/// Represents a notification telling that a reaction has been added
/// to a post previously created from the user.
@immutable
@JsonSerializable(explicitToJson: true)
class PostReactionNotification extends BasePostInteractionNotification {
  /// Represents the value of the reaction that has been added to the post.
  final String reaction;

  PostReactionNotification({
    @required String postId,
    @required User user,
    @required DateTime date,
    @required this.reaction,
    String title,
    String body,
  })  : assert(reaction != null),
        super(
          type: NotificationTypes.REACTION,
          action: NotificationActions.ACTION_SHOW_POST,
          date: date,
          postId: postId,
          user: user,
          title: title,
          body: body,
        );

  factory PostReactionNotification.fromJson(Map<String, dynamic> json) =>
      _$PostReactionNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostReactionNotificationToJson(this);
}

/// Represents a notification telling that the user has been mentioned
/// inside a post or comment.
@immutable
@JsonSerializable(explicitToJson: true)
class PostMentionNotification extends BasePostInteractionNotification {
  PostMentionNotification({
    @required String postId,
    @required User user,
    @required DateTime date,
    String title,
    String body,
  }) : super(
          type: NotificationTypes.MENTION,
          action: NotificationActions.ACTION_SHOW_POST,
          date: date,
          postId: postId,
          user: user,
          title: title,
          body: body,
        );

  factory PostMentionNotification.fromJson(Map<String, dynamic> json) =>
      _$PostMentionNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PostMentionNotificationToJson(this);
}
