import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';

class CreatePostImageItem extends StatelessWidget {
  final double size;
  final PostMedia media;

  const CreatePostImageItem({
    Key key,
    @required this.media,
    this.size = 100,
  })  : assert(media != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: media.isLocal
              ? Image.file(
                  File(media.uri),
                  height: size,
                  width: size,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  media.uri,
                  height: size,
                  width: size,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () {
              BlocProvider.of<PostInputBloc>(context).add(ImageRemoved(media));
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF000000).withOpacity(0.60),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                MooncakeIcons.cross,
                size: size / 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
