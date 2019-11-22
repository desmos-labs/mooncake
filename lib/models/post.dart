import 'package:desmosdemo/models/like.dart';
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
  final String owner;

  final bool liked;
  final List<Like> likes;
  final List<Post> children;

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
    @required this.children,
  })  : assert(id != null),
        assert(parentId != null),
        assert(message != null),
        assert(created != null),
        assert(lastEdited != null),
        assert(allowsComments != null),
        assert(owner != null),
        assert(likes != null),
        assert(children != null);

  Post copyWith({
    id,
    parentId,
    message,
    created,
    lastEdited,
    allowsComments,
    owner,
    likes,
    children,
  }) {
    return Post(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      message: message ?? this.message,
      created: created ?? this.created,
      lastEdited: lastEdited ?? this.lastEdited,
      allowsComments: allowsComments ?? this.allowsComments,
      owner: owner ?? this.owner,
      likes: likes ?? this.likes,
      children: children ?? this.children,
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
      this.owner
    ];
  }
}
