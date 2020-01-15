import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

part 'genesis_response.g.dart';

/// Represents the contents of the response that is returned from the RPC
/// upon querying the /genesis endpoint.
@JsonSerializable(explicitToJson: true)
class GenesisResponse implements Equatable {
  @JsonKey(name: "result")
  final Result result;

  GenesisResponse({
    @required this.result,
  }) : assert(result != null);

  @override
  List<Object> get props => [result];

  factory GenesisResponse.fromJson(Map<String, dynamic> json) =>
      _$GenesisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenesisResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Result implements Equatable {
  @JsonKey(name: "genesis")
  final Genesis genesis;

  Result({
    @required this.genesis,
  }) : assert(genesis != null);

  @override
  List<Object> get props => [genesis];

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Genesis implements Equatable {
  @JsonKey(name: "genesis_time")
  final String genesisTime;

  @JsonKey(name: "app_state")
  final AppState appState;

  Genesis({
    @required this.genesisTime,
    @required this.appState,
  })  : assert(genesisTime != null),
        assert(appState != null);

  @override
  List<Object> get props => [genesisTime, appState];

  factory Genesis.fromJson(Map<String, dynamic> json) =>
      _$GenesisFromJson(json);

  Map<String, dynamic> toJson() => _$GenesisToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AppState implements Equatable {
  @JsonKey(name: "posts")
  final PostsState postsState;

  AppState({@required this.postsState}) : assert(postsState != null);

  @override
  List<Object> get props => [postsState];

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PostsState implements Equatable {
  @JsonKey(name: "posts")
  final List<Post> posts;

  @JsonKey(name: "reactions")
  final Map<String, List<Reaction>> reactions;

  PostsState({@required this.posts, @required this.reactions});

  @override
  List<Object> get props => [posts, reactions];

  factory PostsState.fromJson(Map<String, dynamic> json) =>
      _$PostsStateFromJson(json);

  Map<String, dynamic> toJson() => _$PostsStateToJson(this);
}
