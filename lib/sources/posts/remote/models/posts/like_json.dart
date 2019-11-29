import 'package:json_annotation/json_annotation.dart';

part 'like_json.g.dart';

@JsonSerializable()
class LikeJson {
  LikeJson();

  factory LikeJson.fromJson(Map<String, dynamic> json) =>
      _$LikeJsonFromJson(json);

  Map<String, dynamic> toJson() => _$LikeJsonToJson(this);
}
