import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'post_media.g.dart';

/// Represents a single media inside the list of post medias.
@immutable
@JsonSerializable(explicitToJson: true)
class PostMedia extends Equatable {
  /// Contains all the mime types of medias supported
  static const List<String> IMAGES_MIME_TYPES = [
    "image/jpeg",
    "image/png",
    "image/gif"
  ];

  @JsonKey(name: "uri")
  final String url;

  @JsonKey(ignore: true)
  bool get isLocal => !url.startsWith("http");

  @JsonKey(name: "mime_type")
  final String mimeType;

  bool get isImage => IMAGES_MIME_TYPES.contains(mimeType);

  PostMedia({@required this.url, @required this.mimeType})
      : assert(url != null),
        assert(mimeType != null);

  @override
  List<Object> get props => [url, mimeType];

  factory PostMedia.fromJson(Map<String, dynamic> json) =>
      _$PostMediaFromJson(json);

  Map<String, dynamic> toJson() => _$PostMediaToJson(this);

  /// Allows to create a new [PostMedia] instance with the data contained
  /// inside the invoking object replaced with the ones specified as
  /// arguments.
  PostMedia copyWith({
    String url,
    String mimeType,
  }) {
    return PostMedia(
      url: url ?? this.url,
      mimeType: mimeType ?? this.mimeType,
    );
  }
}
