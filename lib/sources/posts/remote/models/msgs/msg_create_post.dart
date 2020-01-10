import 'package:sacco/sacco.dart';

class MsgCreatePost extends StdMsg {
  final String parentId;
  final String message;
  final bool allowsComments;
  final String subspace;
  final Map<String, String> optionalData;
  final String creator;

  MsgCreatePost({
    this.parentId,
    this.message,
    this.allowsComments,
    this.subspace,
    this.optionalData,
    this.creator,
  })  : assert(parentId != null),
        assert(message != null),
        assert(allowsComments != null),
        assert(subspace != null),
        assert(creator != null),
        super(type: "desmos/MsgCreatePost", value: {
          "parent_id": parentId,
          "message": message,
          "allows_comments": allowsComments,
          "subspace": subspace,
          "optional_data": optionalData ?? Map(),
          "creator": creator,
        });
}
