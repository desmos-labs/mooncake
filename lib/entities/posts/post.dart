import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'post.g.dart';

/// Represents a generic post
@immutable
@JsonSerializable(explicitToJson: true)
class Post extends Equatable implements Comparable<Post> {
  /// Represents the date format that should be used to format and parse
  /// post-related date values.
  static const DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  static const STATUS_FIELD = 'status';

  /// Identifier used to reference posts status value.
  static const STATUS_VALUE_FIELD = '${STATUS_FIELD}.value';

  /// Identifier used to reference the data associated to the post status.
  static const STATUS_DATA_FIELD = '${STATUS_FIELD}.data';

  /// Identifier used to reference the posts' parent id.
  static const PARENT_ID_FIELD = 'parent_id';

  /// Identifier used to reference the post creation date.
  static const DATE_FIELD = 'created';

  static const LAST_EDITED_FIELD = 'last_edited';

  /// Identifier used to reference post ids.
  static const ID_FIELD = 'id';

  /// Identifier used to reference the hidden field or not.
  static const HIDDEN_FIELD = 'hidden';

  /// Identifier used to reference the user field.
  static const OWNER_FIELD = 'user';

  static const LINK_PREVIEW_FIELD = 'link_preview';

  static const REACTIONS_FIELD = 'reactions';

  static const MEDIA_FIELD = 'media';

  static const POLL_FIELD = 'poll';

  static const COMMENTS_FIELD = 'children';

  /// Returns the current date and time in UTC time zone, formatted as
  /// it should be to be used as a post creation date or last edit date.
  static String getDateStringNow() {
    final formatter = DateFormat(DATE_FORMAT);
    return formatter.format(DateTime.now().toUtc());
  }

  @JsonKey(name: ID_FIELD)
  final String id;

  @JsonKey(name: PARENT_ID_FIELD, nullable: true)
  final String parentId;

  @JsonKey(name: 'message', nullable: true)
  final String message;

  /// RFC3339-formatted creation date
  @JsonKey(name: DATE_FIELD)
  final String created;

  @JsonKey(name: LAST_EDITED_FIELD)
  final String lastEdited;

  @JsonKey(name: 'allows_comments')
  final bool allowsComments;

  @JsonKey(name: 'subspace')
  final String subspace;

  @JsonKey(name: OWNER_FIELD)
  final User owner;

  @JsonKey(name: 'optional_data', defaultValue: {})
  final Map<String, String> optionalData;

  @JsonKey(name: MEDIA_FIELD, defaultValue: [])
  final List<PostMedia> medias;

  @JsonKey(name: POLL_FIELD, nullable: true)
  final PostPoll poll;

  @JsonKey(name: REACTIONS_FIELD, defaultValue: [])
  final List<Reaction> reactions;

  @JsonKey(name: COMMENTS_FIELD, defaultValue: [])
  final List<String> commentsIds;

  /// Tells if the post has been synced with the blockchain or not
  @JsonKey(name: STATUS_FIELD, fromJson: _postStatusFromJson)
  final PostStatus status;

  /// Static method used to implement a custom deserialization of posts.
  static PostStatus _postStatusFromJson(Map<String, dynamic> json) {
    return json == null
        ? PostStatus(value: PostStatusValue.TX_SUCCESSFULL)
        : PostStatus.fromJson(json);
  }

  /// Tells whether or not the post has been hidden from the user.
  @JsonKey(name: HIDDEN_FIELD, defaultValue: false)
  final bool hidden;

  /// Represents the link preview associated to this post
  @JsonKey(name: LINK_PREVIEW_FIELD, nullable: true)
  final RichLinkPreview linkPreview;

  Post({
    @required this.id,
    this.parentId = '',
    this.message,
    @required this.created,
    this.lastEdited,
    this.allowsComments = false,
    @required this.subspace,
    this.optionalData = const {},
    @required this.owner,
    List<PostMedia> medias = const [],
    this.poll,
    List<Reaction> reactions = const [],
    List<String> commentsIds = const [],
    @required this.status,
    this.hidden = false,
    this.linkPreview,
  })  : assert(id != null),
        assert(created != null),
        assert(subspace != null),
        assert(owner != null),
        medias = medias ?? const [],
        reactions = reactions ?? const [],
        reactionsCount = groupBy<Reaction, String>(
          (reactions),
          (r) => r.value,
        ).map((rune, reactions) => MapEntry(reactions[0], reactions.length)),
        commentsIds = commentsIds ?? const [],
        assert(message != null || medias?.isNotEmpty == true || poll != null);

  /// Returns the posts' data as a [DateTime] object.
  DateTime get dateTime {
    return DateTime.parse(created);
  }

  /// Tells if this post has a valid parent post or not.
  bool get hasParent {
    return parentId != null && parentId.trim().isNotEmpty;
  }

  /// Returns only the list of images.
  List<PostMedia> get images {
    return medias?.where((element) => element.isImage)?.toList() ?? [];
  }

  /// Tells whether or not it contains local medias.
  bool get containsLocalMedias {
    return medias.any((media) => media.isLocal);
  }

  /// Contains a list of all the reactions and the respective count.
  final Map<Reaction, int> reactionsCount;

  /// Returns the list of all the likes that have been added.
  List<Reaction> get likes {
    return reactions?.toSet()?.where((reaction) => reaction.isLike)?.toList() ??
        [];
  }

  /// Returns the SHA-256 of all the posts contents as a JSON object.
  /// Some contents are excluded. Such as:
  /// - the date
  /// - the id
  /// - the status
  /// - the link preview
  /// - the reactions
  /// - the comments
  String hashContents() {
    final json = toJson();
    json.remove(DATE_FIELD);
    json.remove(LAST_EDITED_FIELD);
    json.remove(ID_FIELD);
    json.remove(STATUS_FIELD);
    json.remove(LINK_PREVIEW_FIELD);
    json.remove(REACTIONS_FIELD);
    json.remove(COMMENTS_FIELD);
    json.remove(MEDIA_FIELD);

    json.remove(POLL_FIELD);
    json['poll_data'] = poll?.hashContents();

    return sha256.convert(utf8.encode(jsonEncode(json))).toString();
  }

  /// Returns a new [Post] having the same data as `this` one, but
  /// with the specified data replaced.
  Post copyWith({
    String id,
    PostStatus status,
    String parentId,
    String message,
    String created,
    String lastEdited,
    bool allowsComments,
    String subspace,
    Map<String, String> optionalData,
    User owner,
    List<PostMedia> medias,
    PostPoll poll,
    List<Reaction> reactions,
    List<String> commentsIds,
    bool hidden,
    RichLinkPreview linkPreview,
  }) {
    return Post(
      status: status ?? this.status,
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      message: message ?? this.message,
      created: created ?? this.created,
      lastEdited: lastEdited ?? this.lastEdited,
      allowsComments: allowsComments ?? this.allowsComments,
      subspace: subspace ?? this.subspace,
      optionalData: optionalData ?? this.optionalData,
      owner: owner ?? this.owner,
      medias: medias ?? this.medias,
      poll: poll ?? this.poll,
      reactions: reactions ?? this.reactions,
      commentsIds: commentsIds ?? this.commentsIds,
      hidden: hidden ?? this.hidden,
      linkPreview: linkPreview ?? this.linkPreview,
    );
  }

  @override
  int compareTo(Post other) {
    return created.compareTo(other.created);
  }

  @override
  List<Object> get props {
    return [
      id,
      parentId,
      message,
      created,
      lastEdited,
      allowsComments,
      subspace,
      owner,
      optionalData,
      medias,
      poll,
      reactions,
      commentsIds,
      status,
      hidden,
      linkPreview,
    ];
  }

  @override
  String toString() {
    return 'Post { '
        'id: $id, '
        'parentId: $parentId, '
        'message: $message, '
        'created: $created, '
        'lastEdited: $lastEdited, '
        'allowsComments: $allowsComments, '
        'subspace: $subspace, '
        'owner: $owner, '
        'optionalData: $optionalData, '
        'medias: $medias, '
        'poll: $poll, '
        'reactions: $reactions, '
        'commentIds: $commentsIds, '
        'status: $status, '
        'hidden: $hidden, '
        'linkPreview: $linkPreview '
        '}';
  }

  static Post fromJson(Map<String, dynamic> json) {
    return _$PostFromJson(json);
  }

  static Map<String, dynamic> asJson(Post post) {
    return post.toJson();
  }

  Map<String, dynamic> toJson() {
    return _$PostToJson(this);
  }
}
