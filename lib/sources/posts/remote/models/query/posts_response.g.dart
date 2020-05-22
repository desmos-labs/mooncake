// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostsResponse _$PostsResponseFromJson(Map<String, dynamic> json) {
  return PostsResponse(
    height: json['height'] as String,
    posts: (json['result'] as List)
        ?.map(
            (e) => e == null ? null : Post.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostsResponseToJson(PostsResponse instance) =>
    <String, dynamic>{
      'height': instance.height,
      'result': instance.posts,
    };
