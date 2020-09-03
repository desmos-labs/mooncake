import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/blocs/export.dart';
import '../export.dart';

/// Represents the editor that allows the user to change his profile picture.
class AccountProfileImageEditor extends StatelessWidget {
  final double size;
  final double border;

  const AccountProfileImageEditor({
    Key key,
    @required this.size,
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
              AccountAvatar(
                user: state.account,
                border: border,
                size: size,
              ),
              Opacity(
                opacity: 0.5,
                child: Icon(
                  MooncakeIcons.camera,
                  color: Theme.of(context).iconTheme.color,
                ),
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
