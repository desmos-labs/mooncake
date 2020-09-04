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
    'image/jpeg',
    'image/png',
    'image/gif'
  ];

  @JsonKey(name: 'uri')
  final String uri;

  @JsonKey(name: 'mime_type')
  final String mimeType;

  const PostMedia({
    @required this.uri,
    @required this.mimeType,
  })  : assert(uri != null),
        assert(mimeType != null);

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    return _$PostMediaFromJson(json);
  }

  /// Tells whether the image is stored only locally or not.
  bool get isLocal {
    return !uri.startsWith('http');
  }

  /// Tells whether this media represents an image or not.
  bool get isImage {
    return IMAGES_MIME_TYPES.contains(mimeType);
  }

  /// Allows to create a new [PostMedia] instance with the data contained
  /// inside the invoking object replaced with the ones specified as
  /// arguments.
  PostMedia copyWith({
    String uri,
    String mimeType,
  }) {
    return PostMedia(
      uri: uri ?? this.uri,
      mimeType: mimeType ?? this.mimeType,
    );
  }

  Map<String, dynamic> toJson() {
    return _$PostMediaToJson(this);
  }

  @override
  List<Object> get props {
    return [uri, mimeType];
  }
}
