import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a single post image preview item.
class ImagePreviewItem extends StatelessWidget {
  final double size;
  final File image;

  const ImagePreviewItem({
    Key key,
    @required this.size,
    @required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderWidth = 1.0;
    final radius = BorderRadius.circular(10);

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.grey[500]),
            borderRadius: radius,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Image.file(
              image,
              height: size - 2 * borderWidth,
              width: size - 2 * borderWidth,
              fit: BoxFit.cover,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // ignore: close_sinks
            final bloc = BlocProvider.of<PostInputBloc>(context);
            bloc.add(ImageRemoved(this.image));
          },
          icon: Icon(FontAwesomeIcons.trash),
        ),
      ],
    );
  }
}
