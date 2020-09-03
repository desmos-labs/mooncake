import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'post_notifications.g.dart';

/// Represents a basic notification that represents an interaction with a post.
@immutable
abstract class BasePostInteractionNotification extends NotificationData {
  /// Represents the ID of post towards which this notification is directed.
  @JsonKey(name: 'post_id', nullable: false)
  final String postId;

  /// Represents the user that has interacted with the post.
  @JsonKey(name: 'user', nullable: false)
  final User user;

  const BasePostInteractionNotification({
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
  List<Object> get props {
    return super.props + [postId, user];
  }
}

/// Represents a notification telling that a comment has been added to
/// a post that was previously created from the user.
@immutable
@JsonSerializable(explicitToJson: true)
class PostCommentNotification extends BasePostInteractionNotification {
  /// Represents the comment message.
  @JsonKey(name: 'message')
  final String comment;

  const PostCommentNotification({
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
  List<Object> get props {
    return super.props + [comment];
  }

  factory PostCommentNotification.fromJson(Map<String, dynamic> json) {
    return _$PostCommentNotificationFromJson(json);
  }

  @Deprecated('Use asJson instead')
  @override
  Map<String, dynamic> toJson() {
    return _$PostCommentNotificationToJson(this);
  }
}

/// Represents a notification telling that the user has been mentioned
/// inside a post or comment.
@immutable
@JsonSerializable(explicitToJson: true)
class PostMentionNotification extends BasePostInteractionNotification {
  /// Represents the text containing the mention.
  @JsonKey(name: 'text')
  final String text;

  const PostMentionNotification({
    @required String postId,
    @required User user,
    @required DateTime date,
    @required this.text,
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

  factory PostMentionNotification.fromJson(Map<String, dynamic> json) {
    return _$PostMentionNotificationFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$PostMentionNotificationToJson(this);
  }

  @override
  List<Object> get props => super.props + [text];
}

/// Represents a notification telling the user he's been tagged inside a post.
@immutable
@JsonSerializable(explicitToJson: true)
class PostTagNotification extends BasePostInteractionNotification {
  const PostTagNotification({
    @required String postId,
    @required User user,
    @required DateTime date,
    String title,
    String body,
  }) : super(
          type: NotificationTypes.TAG,
          action: NotificationActions.ACTION_SHOW_POST,
          date: date,
          postId: postId,
          user: user,
          title: title,
          body: body,
        );

  factory PostTagNotification.fromJson(Map<String, dynamic> json) {
    return _$PostTagNotificationFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$PostTagNotificationToJson(this);
  }
}

/// Represents a notification telling that a reaction has been added
/// to a post previously created from the user.
@immutable
@JsonSerializable(explicitToJson: true)
class PostReactionNotification extends BasePostInteractionNotification {
  /// Represents the value of the reaction that has been added to the post.
  @JsonKey(name: 'reaction')
  final String reaction;

  const PostReactionNotification({
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

  factory PostReactionNotification.fromJson(Map<String, dynamic> json) {
    return _$PostReactionNotificationFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$PostReactionNotificationToJson(this);
  }

  @override
  List<Object> get props => super.props + [reaction];
}

/// Represents a notification telling that a like has been added
/// to a post previously created from the user.
@immutable
@JsonSerializable(explicitToJson: true)
class PostLikeNotification extends BasePostInteractionNotification {
  const PostLikeNotification({
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

  factory PostLikeNotification.fromJson(Map<String, dynamic> json) {
    return _$PostLikeNotificationFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$PostLikeNotificationToJson(this);
  }
}
