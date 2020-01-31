import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'post_media.g.dart';

/// Represents a single media inside the list of post medias.
@JsonSerializable()
class PostMedia extends Equatable {
  @JsonKey(name: "uri")
  final String url;

  @JsonKey(name: "mimetype")
  final String mimeType;

  PostMedia({@required this.url, @required this.mimeType})
      : assert(url != null),
        assert(mimeType != null);

  @override
  List<Object> get props => [url, mimeType];

  factory PostMedia.fromJson(Map<String, dynamic> json) =>
      _$PostMediaFromJson(json);

  Map<String, dynamic> toJson() => _$PostMediaToJson(this);
}
