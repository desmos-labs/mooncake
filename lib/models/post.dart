import 'package:desmosdemo/models/like.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'post.g.dart';

/// Represents a generic post
@JsonSerializable(explicitToJson: true)
class Post implements Equatable {
  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "parent_id")
  final String parentId;

  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "created")
  final String created;

  @JsonKey(name: "lastEdited")
  final String lastEdited;

  @JsonKey(name: "allowsComments")
  final bool allowsComments;

  @JsonKey(name: "owner")
  final User owner;

  @JsonKey(ignore: true)
  bool get liked =>
      likes != null && likes.where((l) => l.owner == owner.address).isNotEmpty;

  @JsonKey(name: "likes")
  final List<Like> likes;

  @JsonKey(name: "comments_ids")
  final List<String> commentsIds;

  /// Tells if the post has been synced with the blockchain or not
  @JsonKey(name: "synced")
  final bool synced;

  Post({
    @required this.id,
    @required this.parentId,
    @required this.message,
    @required this.created,
    @required this.lastEdited,
    @required this.allowsComments,
    @required this.owner,
    @required this.likes,
    @required this.commentsIds,
    @required this.synced,
  })  : assert(id != null),
        assert(parentId != null),
        assert(message != null),
        assert(created != null),
        assert(lastEdited != null),
        assert(allowsComments != null),
        assert(owner != null),
        assert(likes != null),
        assert(commentsIds != null);

  Post copyWith({
    String id,
    String parentId,
    String message,
    String created,
    String lastEdited,
    bool allowsComments,
    User owner,
    List<Like> likes,
    List<Post> children,
    bool synced,
  }) {
    final newOwner = owner ?? this.owner;
    return Post(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      message: message ?? this.message,
      created: created ?? this.created,
      lastEdited: lastEdited ?? this.lastEdited,
      allowsComments: allowsComments ?? this.allowsComments,
      owner: newOwner,
      likes: likes ?? this.likes,
      commentsIds: children ?? this.commentsIds,
      synced: synced ?? this.synced,
    );
  }

  @override
  List<Object> get props {
    return [
      this.id,
      this.parentId,
      this.message,
      this.created,
      this.lastEdited,
      this.allowsComments,
      this.owner,
      this.liked,
      this.likes,
      this.commentsIds,
      this.synced,
    ];
  }

  @override
  String toString() => 'Post { '
      'id: $id, '
      'parentId: $parentId, '
      'message: $message, '
      'created: $created, '
      'lastEdited: $lastEdited, '
      'allowsComments: $allowsComments, '
      'owner: $owner, '
      'liked: $liked, '
      'likes: $likes, '
      'commentsIds: $commentsIds '
      'synced: $synced '
      '}';

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
