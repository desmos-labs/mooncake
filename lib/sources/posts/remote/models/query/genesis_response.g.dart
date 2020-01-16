// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genesis_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenesisResponse _$GenesisResponseFromJson(Map<String, dynamic> json) {
  return GenesisResponse(
    result: json['result'] == null
        ? null
        : Result.fromJson(json['result'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GenesisResponseToJson(GenesisResponse instance) =>
    <String, dynamic>{
      'result': instance.result?.toJson(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
    genesis: json['genesis'] == null
        ? null
        : Genesis.fromJson(json['genesis'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'genesis': instance.genesis?.toJson(),
    };

Genesis _$GenesisFromJson(Map<String, dynamic> json) {
  return Genesis(
    genesisTime: json['genesis_time'] as String,
    appState: json['app_state'] == null
        ? null
        : AppState.fromJson(json['app_state'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GenesisToJson(Genesis instance) => <String, dynamic>{
      'genesis_time': instance.genesisTime,
      'app_state': instance.appState?.toJson(),
    };

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
    postsState: json['posts'] == null
        ? null
        : PostsState.fromJson(json['posts'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'posts': instance.postsState?.toJson(),
    };

PostsState _$PostsStateFromJson(Map<String, dynamic> json) {
  return PostsState(
    posts: (json['posts'] as List)
        ?.map(
            (e) => e == null ? null : Post.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    reactions: (json['reactions'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : Reaction.fromJson(e as Map<String, dynamic>))
              ?.toList()),
    ),
  );
}

Map<String, dynamic> _$PostsStateToJson(PostsState instance) =>
    <String, dynamic>{
      'posts': instance.posts?.map((e) => e?.toJson())?.toList(),
      'reactions': instance.reactions
          ?.map((k, e) => MapEntry(k, e?.map((e) => e?.toJson())?.toList())),
    };
