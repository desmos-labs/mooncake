import 'package:alan/alan.dart';
import 'package:mooncake/sources/sources.dart';

/// Initializes the codec to properly register all the types.
void initializeCodec() {
  Codec.registerMsgType('desmos/MsgCreatePost', MsgCreatePost);
  Codec.registerMsgType('desmos/MsgAddPostReaction', MsgAddPostReaction);
  Codec.registerMsgType(
    'desmos/MsgRemovePostReaction',
    MsgRemovePostReaction,
  );
}
