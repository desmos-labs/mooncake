import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/blocs/export.dart';
import '../export.dart';

/// Represents the editor that can be used to change the account cover.
class AccountCoverImageEditor extends StatelessWidget {
  final double height;

  const AccountCoverImageEditor({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      builder: (context, state) {
        return InkWell(
          onTap: () => _chooseImage(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AccountCoverImageViewer(
                height: height,
                coverImage: state.account.coverPicUri,
              ),
              Opacity(
                opacity: 0.5,
                child: Icon(MooncakeIcons.camera),
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
        BlocProvider.of<EditAccountBloc>(context).add(CoverChanged(image));
      },
    );
  }
}
