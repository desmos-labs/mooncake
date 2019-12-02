import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'like_json.g.dart';

@JsonSerializable(explicitToJson: true)
class LikeJson {
  @JsonKey(name: "createod")
  final String created;

  @JsonKey(name: "owner")
  final String owner;

  LikeJson({
    @required this.owner,
    @required this.created,
  })  : assert(owner != null),
        assert(created != null);

  factory LikeJson.fromJson(Map<String, dynamic> json) =>
      _$LikeJsonFromJson(json);

  Map<String, dynamic> toJson() => _$LikeJsonToJson(this);
}
