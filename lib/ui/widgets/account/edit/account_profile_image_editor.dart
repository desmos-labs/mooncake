import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'image_picker.dart';

/// Represents the editor that allows the user to change his profile picture.
class AccountProfileImageEditor extends StatelessWidget {
  final double radius;
  final double border;

  const AccountProfileImageEditor({
    Key key,
    @required this.radius,
    @required this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      builder: (context, state) {
        final hasImage =
            state.coverImage != null && !(state.coverImage is NoUserImage);

        ImageProvider coverImage;
        final coverImageValue = state.coverImage;
        if (coverImageValue is LocalUserImage) {
          coverImage = FileImage(coverImageValue.image);
        } else if (coverImageValue is NetworkUserImage) {
          coverImage = NetworkImage(coverImageValue.url);
        }

        return CircleAvatar(
          radius: radius,
          backgroundColor: Theme.of(context).backgroundColor,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(1000),
            child: InkWell(
              onTap: () => _chooseImage(context),
              borderRadius: BorderRadius.circular(1000),
              child: CircleAvatar(
                radius: radius - border,
                backgroundColor: coverImage != null
                    ? null
                    : Theme.of(context).primaryColor.withOpacity(0.25),
                backgroundImage: coverImage,
                child: Icon(
                  MooncakeIcons.camera,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _chooseImage(BuildContext context) {
    showImagePicker(context: context, onImageChosen: (image) {
      BlocProvider.of<EditAccountBloc>(context).add(ProfilePicChanged(image));
    });
  }
}
