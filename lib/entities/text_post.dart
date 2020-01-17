import 'package:mooncake/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'text_post.g.dart';

/// Represents a generic post
@immutable
@JsonSerializable(explicitToJson: true)
class Post implements Equatable, Comparable<Post> {
  /// Represents the date format that should be used to format and parse
  /// post-related date values.
  static const DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  /// Returns the current date and time in UTC time zone, formatted as
  /// it should be to be used as a post creation date or last edit date.
  static String getDateStringNow() {
    final formatter = DateFormat(DATE_FORMAT);
    return formatter.format(DateTime.now().toUtc());
  }

  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "parent_id")
  final String parentId;

  /// Tells if this post has a valid parent post or not.
  @JsonKey(ignore: true)
  bool get hasParent =>
      parentId != null && parentId.isNotEmpty && parentId != "0";

  @JsonKey(name: "message")
  final String message;

  /// RFC3339-formatted creation date
  @JsonKey(name: "created")
  final String created;

  @JsonKey(ignore: true)
  DateTime get dateTime {
    return DateTime.parse(created);
  }

  @JsonKey(name: "last_edited")
  final String lastEdited;

  @JsonKey(name: "allows_comments")
  final bool allowsComments;

  @JsonKey(name: "subspace")
  final String subspace;

  @JsonKey(name: "creator")
  final String owner;

  @JsonKey(name: "optional_data")
  final Map<String, String> optionalData;

  @JsonKey(name: "reactions")
  final List<Reaction> reactions;

  @JsonKey(name: "children")
  final List<String> commentsIds;

  /// Tells if the post has been synced with the blockchain or not
  @JsonKey(name: "status")
  final PostStatus status;

  Post({
    @required this.id,
    this.parentId = "0",
    @required this.message,
    @required this.created,
    this.lastEdited,
    this.allowsComments = false,
    @required this.subspace,
    this.optionalData = const {},
    @required this.owner,
    List<Reaction> reactions = const [],
    List<String> commentsIds = const [],
    this.status = const PostStatus(value: PostStatusValue.TO_BE_SYNCED),
  })  : assert(id != null),
        assert(message != null),
        assert(created != null),
        assert(subspace != null),
        assert(owner != null),
        this.reactions = reactions ?? [],
        this.commentsIds = commentsIds ?? [];

  Post copyWith({
    String parentId,
    String message,
    String created,
    String lastEdited,
    bool allowsComments,
    String subspace,
    Map<String, String> optionalData,
    String owner,
    List<Reaction> reactions,
    List<String> commentsIds,
    PostStatus status,
  }) {
    return Post(
      id: this.id,
      parentId: parentId ?? this.parentId,
      message: message ?? this.message,
      created: created ?? this.created,
      lastEdited: lastEdited ?? this.lastEdited,
      allowsComments: allowsComments ?? this.allowsComments,
      subspace: subspace ?? this.subspace,
      optionalData: optionalData ?? this.optionalData,
      owner: owner ?? this.owner,
      reactions: reactions ?? this.reactions,
      commentsIds: commentsIds ?? this.commentsIds,
      status: status ?? this.status,
    );
  }

  @override
  int compareTo(Post other) {
    return created.compareTo(other.created);
  }

  @override
  List<Object> get props => [
        this.id,
        this.parentId,
        this.message,
        this.created,
        this.lastEdited,
        this.allowsComments,
        this.subspace,
        this.optionalData,
        this.owner,
        this.reactions,
        this.commentsIds,
        this.status,
      ];

  @override
  String toString() => 'Post { '
      'id: $id, '
      'parentId: $parentId, '
      'message: $message, '
      'created: $created, '
      'lastEdited: $lastEdited, '
      'allowsComments: $allowsComments, '
      'subspace: $subspace, '
      'optionalData: $optionalData, '
      'owner: $owner, '
      'reactions: $reactions, '
      'commentsIds: $commentsIds, '
      'synced: $status '
      '}';

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
