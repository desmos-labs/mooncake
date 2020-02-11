import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'posts_response.g.dart';

/// Represents the content of the response that is returned from the LCD
/// when querying the /posts endpoint.
@JsonSerializable()
class PostsResponse {
  @JsonKey(name: "height")
  final String height;

  @JsonKey(name: "result")
  final List<Post> posts;

  PostsResponse({
    @required this.height,
    @required this.posts,
  }) : assert(height != null);

  factory PostsResponse.fromJson(Map<String, dynamic> json) =>
      _$PostsResponseFromJson(json);
}
