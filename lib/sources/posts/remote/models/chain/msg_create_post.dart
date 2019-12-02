import 'package:sacco/sacco.dart';

class MsgCreatePost extends StdMsg {
  final String parentId;
  final String message;
  final bool allowsComments;
  final String externalReference;
  final String creator;

  MsgCreatePost({
    this.parentId,
    this.message,
    this.allowsComments,
    this.externalReference,
    this.creator,
  })  : assert(parentId != null),
        assert(message != null),
        assert(allowsComments != null),
        assert(externalReference != null),
        assert(creator != null),
        super(type: "desmos/MsgCreatePost", value: {
          "parent_id": parentId,
          "message": message,
          "allows_comments": allowsComments,
          "external_reference": externalReference,
          "creator": creator,
        });
}
