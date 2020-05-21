import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'image_picker.dart';

import '../view/export.dart';

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
                coverImage: state.account.coverPicUrl,
              ),
              Icon(MooncakeIcons.camera),
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
