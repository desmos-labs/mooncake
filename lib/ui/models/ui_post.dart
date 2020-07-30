import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

import 'link_preview.dart';

/// Contains the data that should be used in order to display a post inside
/// the UI properly.
class UiPost extends Post {
  final RichLinkPreview linkPreview;

  bool get hasLinkPreview => linkPreview != null;

  UiPost({
    @required this.linkPreview,
    @required String id,
    @required String parentId,
    @required String message,
    @required String created,
    @required String lastEdited,
    @required bool allowsComments,
    @required String subspace,
    @required Map<String, String> optionalData,
    @required User owner,
    @required List<PostMedia> medias,
    @required PostPoll poll,
    @required List<Reaction> reactions,
    @required List<String> commentsIds,
    @required PostStatus status,
    @required bool hidden,
  }) : super(
          id: id,
          parentId: parentId,
          message: message,
          created: created,
          lastEdited: lastEdited,
          status: status,
          allowsComments: allowsComments,
          subspace: subspace,
          optionalData: optionalData,
          owner: owner,
          medias: medias,
          poll: poll,
          reactions: reactions,
          commentsIds: commentsIds,
          hidden: hidden,
        );

  @override
  List<Object> get props {
    return super.props + [linkPreview];
  }
}
