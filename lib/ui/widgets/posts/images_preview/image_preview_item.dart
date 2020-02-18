import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

typedef OnMediaTap = void Function(PostMedia);

/// Represents a single post image preview item.
class ImagePreviewItem extends StatelessWidget {
  final allowEdits;
  final double size;
  final PostMedia media;

  final OnMediaTap onTap;

  const ImagePreviewItem({
    Key key,
    this.allowEdits = false,
    @required this.size,
    @required this.media,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderWidth = 1.0;
    final radius = BorderRadius.circular(10);
    final imageSize = size - 2 * borderWidth;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => onTap(media),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.grey[500]),
              borderRadius: radius,
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: media.isLocal
                  ? Image.file(
                      File(media.url),
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      media.url,
                      height: imageSize,
                      width: imageSize,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        if (allowEdits)
          IconButton(
            onPressed: () {
              // ignore: close_sinks
              final bloc = BlocProvider.of<PostInputBloc>(context);
              bloc.add(ImageRemoved(this.media));
            },
            icon: Icon(FontAwesomeIcons.trash),
          ),
      ],
    );
  }
}
