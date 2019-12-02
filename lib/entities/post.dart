import 'package:desmosdemo/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'post.g.dart';

enum PostStatus {
  @JsonValue("synced")
  SYNCED,
  @JsonValue("to_be_synced")
  TO_BE_SYNCED,
  @JsonValue("syncing")
  SYNCING
}

/// Represents a generic post
@immutable
@JsonSerializable(explicitToJson: true)
class Post implements Equatable {
  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "parent_id")
  final String parentId;

  /// Tells if this post has a valid parent post or not.
  @JsonKey(ignore: true)
  bool get hasParent => parentId != null && parentId != "0";

  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "created")
  final String created;

  @JsonKey(name: "lastEdited")
  final String lastEdited;

  @JsonKey(name: "allowsComments")
  final bool allowsComments;

  @JsonKey(name: "externalReference")
  final String externalReference;

  @JsonKey(name: "owner")
  final String owner;

  @JsonKey(ignore: true)
  bool get liked => likes.where((l) => l.owner == owner).isNotEmpty;

  @JsonKey(name: "likes")
  final List<Like> likes;

  /// Tells is this post has already been liked from the user
  /// having the given [address] or not.
  bool containsLikeFromUser(String address) =>
      likes.where((l) => l.owner == address).isNotEmpty;

  @JsonKey(name: "comments_ids")
  final List<String> commentsIds;

  /// Tells if the post has been synced with the blockchain or not
  @JsonKey(name: "status")
  final PostStatus status;

  Post({
    @required this.id,
    @required this.parentId,
    @required this.message,
    @required this.created,
    @required this.lastEdited,
    @required this.allowsComments,
    @required this.externalReference,
    @required this.owner,
    @required this.likes,
    @required this.commentsIds,
    @required this.status,
  })  : assert(id != null),
        assert(message != null),
        assert(created != null),
        assert(allowsComments != null),
        assert(owner != null),
        assert(likes != null),
        assert(commentsIds != null),
        assert(status != null);

  Post copyWith({
    String id,
    String parentId,
    String message,
    String created,
    String lastEdited,
    bool allowsComments,
    String externalReference,
    String owner,
    List<Like> likes,
    List<String> commentsIds,
    PostStatus status,
  }) {
    final newOwner = owner ?? this.owner;
    return Post(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      message: message ?? this.message,
      created: created ?? this.created,
      lastEdited: lastEdited ?? this.lastEdited,
      allowsComments: allowsComments ?? this.allowsComments,
      externalReference: externalReference ?? this.externalReference,
      owner: newOwner,
      likes: likes ?? this.likes,
      commentsIds: commentsIds ?? this.commentsIds,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        this.id,
        this.parentId,
        this.message,
        this.created,
        this.lastEdited,
        this.allowsComments,
        this.externalReference,
        this.owner,
        this.liked,
        this.likes,
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
      'externalRerence: $externalReference, '
      'owner: $owner, '
      'liked: $liked, '
      'likes: $likes, '
      'commentsIds: $commentsIds '
      'synced: $status '
      '}';

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
