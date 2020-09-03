import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

import 'chain_poll_data.dart';

export 'chain_poll_data.dart';
export 'chain_poll_option.dart';

part 'msg_create_post.g.dart';

/// Represents the message that should be used when creating a new post or
/// comment.
@immutable
@reflector
@JsonSerializable(explicitToJson: true)
class MsgCreatePost extends StdMsg {
  @JsonKey(name: 'parent_id')
  final String parentId;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'allows_comments')
  final bool allowsComments;

  @JsonKey(name: 'subspace')
  final String subspace;

  @JsonKey(name: 'optional_data', includeIfNull: false)
  final Map<String, String> optionalData;

  @JsonKey(name: 'creator')
  final String creator;

  @JsonKey(name: 'attachments', includeIfNull: false)
  final List<PostMedia> medias;

  @JsonKey(name: 'poll_data', includeIfNull: false)
  final ChainPollData poll;

  MsgCreatePost({
    @required this.parentId,
    @required this.message,
    @required this.allowsComments,
    @required this.subspace,
    @required this.optionalData,
    @required this.creator,
    @required this.medias,
    @required this.poll,
  })  : assert(parentId != null),
        assert(allowsComments != null),
        assert(subspace != null),
        assert(creator != null);

  @override
  List<Object> get props {
    return [
      parentId,
      message,
      allowsComments,
      subspace,
      optionalData,
      creator,
      medias,
      poll,
    ];
  }

  @override
  Map<String, dynamic> asJson() {
    return _$MsgCreatePostToJson(this);
  }

  factory MsgCreatePost.fromJson(Map<String, dynamic> json) {
    return _$MsgCreatePostFromJson(json);
  }

  @override
  Exception validate() {
    if (message?.isEmpty == true && poll == null && medias?.isEmpty == true) {
      return Exception('Message, medias and poll cannot be all empty');
    }

    if (subspace.isEmpty) {
      return Exception('Subspace cannot be empty');
    }

    if (creator.isEmpty) {
      return Exception('Creator cannot be empty');
    }

    return null;
  }

  @override
  String toString() {
    return 'MsgCreatePost { '
        'parentId: $parentId, '
        'message: $message, '
        'allowsComments: $allowsComments, '
        'subspace: $subspace, '
        'optionalData: $optionalData, '
        'creator: $creator, '
        'medias: $medias,'
        'poll: $poll '
        '}';
  }
}
