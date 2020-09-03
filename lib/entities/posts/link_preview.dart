import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'link_preview.g.dart';

/// Contains all the data that can be used to properly
/// display a rich link preview.
@immutable
@JsonSerializable(explicitToJson: true)
class RichLinkPreview extends Equatable {
  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'appleIcon')
  final String appleIcon;

  @JsonKey(name: 'favIcon')
  final String favIcon;

  @JsonKey(name: 'url')
  final String url;

  RichLinkPreview({
    @required this.title,
    @required this.description,
    @required this.image,
    @required this.appleIcon,
    @required this.favIcon,
    @required this.url,
  });

  factory RichLinkPreview.fromJson(Map<String, dynamic> json) {
    return _$RichLinkPreviewFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RichLinkPreviewToJson(this);
  }

  @override
  List<Object> get props {
    return [
      title,
      description,
      image,
      appleIcon,
      favIcon,
      url,
    ];
  }

  @override
  String toString() {
    return 'RichLinkPreview { '
        'title: $title, '
        'description: $description, '
        'image: $image, '
        'favIcon: $favIcon, '
        'url: $url, '
        'appleIcon: $appleIcon, '
        '}';
  }
}
