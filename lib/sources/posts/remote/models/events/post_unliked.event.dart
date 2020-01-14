import 'package:mooncake/sources/sources.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PostUnlikedEvent extends ChainEvent implements Equatable {
  final String postId;
  final String liker;

  PostUnlikedEvent({
    @required this.postId,
    @required this.liker,
    @required String height,
  })  : assert(postId != null),
        assert(liker != null),
        super(height: height);

  @override
  List<Object> get props => [postId, liker];
}
