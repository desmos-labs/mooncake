import 'package:dwitter/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'post.g.dart';

enum PostStatus {
  @JsonValue("to_be_synced")
  TO_BE_SYNCED,
  @JsonValue("syncing")
  SYNCING,
  @JsonValue("synced")
  SYNCED,
}

String createPostExternalReference(String postId) {
  return "dwitter-$postId";
}

String getPostIdByReference(String externalReference) {
  final ref = externalReference?.trim();
  if (ref == null || ref.isEmpty || !ref.contains("dwitter")) {
    return null;
  }

  return ref.split("dwitter-")[1];
}

/// Represents a generic post
@immutable
@JsonSerializable(explicitToJson: true)
class Post implements Equatable, Comparable<Post> {
  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "parentId")
  final String parentId;

  /// Tells if this post has a valid parent post or not.
  @JsonKey(ignore: true)
  bool get hasParent =>
      parentId != null && parentId.isNotEmpty && parentId != "0";

  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "created")
  final String created;

  @JsonKey(ignore: true)
  bool get isCreateBlockHeight => DateTime.tryParse(created) == null;

  @JsonKey(name: "lastEdited")
  final String lastEdited;

  @JsonKey(name: "allowsComments")
  final bool allowsComments;

  @JsonKey(name: "externalReference")
  final String externalReference;

  @JsonKey(name: "owner")
  final String owner;

  @JsonKey(name: "owner_is_user")
  final bool ownerIsUser;

  @JsonKey(name: "liked")
  final bool liked;

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
    @required this.message,
    @required this.created,
    @required this.owner,
    this.parentId = "0",
    this.lastEdited,
    this.allowsComments = false,
    this.externalReference = "",
    this.ownerIsUser = false,
    this.likes = const [],
    this.liked = false,
    this.commentsIds = const [],
    this.status = PostStatus.TO_BE_SYNCED,
  })  : assert(id != null),
        assert(message != null),
        assert(created != null),
        assert(allowsComments != null),
        assert(owner != null),
        assert(likes != null),
        assert(commentsIds != null),
        assert(status != null);

  Post copyWith({
    String parentId,
    String message,
    String created,
    String lastEdited,
    bool allowsComments,
    String externalReference,
    String owner,
    bool ownerIsUser,
    List<Like> likes,
    bool liked,
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
      externalReference: externalReference ?? this.externalReference,
      owner: owner ?? this.owner,
      ownerIsUser: ownerIsUser ?? this.ownerIsUser,
      likes: likes ?? this.likes,
      liked: liked ?? this.liked,
      commentsIds: commentsIds ?? this.commentsIds,
      status: status ?? this.status,
    );
  }

  /// Updates the contents of this post with the one of the new post.
  /// If the new one has the likes or comments changed, the status of this post
  /// will be preserved.
  /// Otherwise, the status of this post will become the one of the updated
  /// one.
  Post updateWith(Post updated) {
    final areLikesChanged = this.likes == updated.likes;
    final areCommentsChanged = this.commentsIds == updated.commentsIds;
    final shouldStatusBeConserved = areLikesChanged || areCommentsChanged;

    return this.copyWith(
      status: shouldStatusBeConserved ? this.status : updated.status,
      likes: (this.likes + updated.likes).toSet().toList(),
      commentsIds: (this.commentsIds + updated.commentsIds).toSet().toList(),
    );
  }

  @override
  int compareTo(Post other) {
    int statusCompare = 0;

    bool onChain = DateTime.tryParse(created) == null;
    bool otherOnChain = DateTime.tryParse(other.created) == null;

    if (!onChain && otherOnChain) {
      statusCompare = 1;
    } else if (onChain && !otherOnChain) {
      statusCompare = -1;
    }

    if (statusCompare != 0) {
      return statusCompare;
    } else if (onChain && otherOnChain) {
      return double.parse(created).compareTo(double.parse(other.created));
    } else {
      return created.compareTo(other.created);
    }
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
        this.ownerIsUser,
        this.likes,
        this.liked,
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
      'ownerIsUser: $ownerIsUser, '
      'likes: $likes, '
      'liked: $liked, '
      'commentsIds: $commentsIds '
      'synced: $status '
      '}';

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
