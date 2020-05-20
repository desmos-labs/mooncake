import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/widgets/account/view/account_profile_image_viewer.dart';

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
        return InkWell(
          onTap: () => _chooseImage(context),
          borderRadius: BorderRadius.circular(1000),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AccountProfileImageViewer(
                profileImage: state.profileImage,
                border: border,
                radius: radius,
              ),
              Icon(
                MooncakeIcons.camera,
                color: Theme.of(context).iconTheme.color,
              ),
            ],
          ),
        );
      },
    );
  }

  void _chooseImage(BuildContext context) {
    showImagePicker(
      context: context,
      onImageChosen: (image) {
        BlocProvider.of<EditAccountBloc>(context).add(ProfilePicChanged(image));
      },
    );
  }
}
