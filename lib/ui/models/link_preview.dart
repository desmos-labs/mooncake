import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Contains all the data that can be used to properly
/// display a rich link preview.
class RichLinkPreview extends Equatable {
  final String title;
  final String description;
  final String image;
  final String appleIcon;
  final String favIcon;
  final String url;

  RichLinkPreview({
    @required this.title,
    @required this.description,
    @required this.image,
    @required this.appleIcon,
    @required this.favIcon,
    @required this.url,
  });

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
}
