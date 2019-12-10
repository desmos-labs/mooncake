import 'package:dwitter/sources/sources.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PostUnlikedEvent implements Equatable, ChainEvent {
  final String postId;
  final String liker;

  PostUnlikedEvent({
    @required this.postId,
    @required this.liker,
  });

  @override
  List<Object> get props => [postId, liker];
}
