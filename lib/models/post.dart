import 'package:desmosdemo/models/like.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a generic post
class Post implements Equatable {
  final String id;
  final String parentId;
  final String message;
  final String created;
  final String lastEdited;
  final bool allowsComments;
  final User owner;

  final bool liked;
  final List<Like> likes;
  final List<String> commentsIds;

  Post({
    @required this.id,
    @required this.parentId,
    @required this.message,
    @required this.created,
    @required this.lastEdited,
    @required this.allowsComments,
    @required this.owner,
    @required this.liked,
    @required this.likes,
    @required this.commentsIds,
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
      liked: likes == null
          ? this.liked
          : likes.where((l) => l.owner == owner.address).first != null,
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
      'commentsIds: $commentsIds'
      '}';
}
