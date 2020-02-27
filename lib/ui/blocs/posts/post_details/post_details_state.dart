import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a generic state that is associated with the screen that
/// shows the details of a post.
abstract class PostDetailsState extends Equatable {
  const PostDetailsState();

  @override
  List<Object> get props => [];
}

/// Represents the state during which the post details are being loaded.
class LoadingPostDetails extends PostDetailsState {
  @override
  String toString() => 'LoadingPostDetails';
}

/// Represents the state that tells the post details have been loaded
/// properly and are ready to be shown.
class PostDetailsLoaded extends PostDetailsState {
  final Post post;
  final List<Post> comments;

  PostDetailsLoaded({@required this.post, @required this.comments});

  @override
  List<Object> get props => [post, comments];
}


