import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents a single image items that should be displayed as part
/// of the post content.
class PostContentImage extends StatelessWidget {
  final PostMedia media;
  final List<PostMedia> allMedia;
  final int index;

  const PostContentImage({
    Key key,
    this.media,
    this.allMedia,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => _openImage(context),
        child: media.isLocal ? _localImage(media.uri) : _remoteImage(media.uri),
      ),
    );
  }

  Widget _localImage(String url) {
    return Image(
      width: double.infinity,
      fit: BoxFit.cover,
      image: FileImage(File(url)),
    );
  }

  Widget _remoteImage(String url) {
    return CachedNetworkImage(
      width: double.infinity,
      fit: BoxFit.cover,
      imageUrl: media.uri,
      placeholder: (context, _) => LoadingIndicator(),
    );
  }

  void _openImage(BuildContext context) async {
    // wingman revert later
    BlocProvider.of<NavigatorBloc>(context).add(NavigateToLightbox(
      photos: [...allMedia, ...allMedia],
      selectedIndex: index,
    ));
    // if (await canLaunch(media.uri)) {
    //   await launch(media.uri);
    // }
  }
}
