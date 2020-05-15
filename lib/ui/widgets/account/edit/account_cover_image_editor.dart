import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

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
        return Stack(
          alignment: Alignment.center,
          children: [
            _background(context, state),
            IconButton(
              icon: Icon(MooncakeIcons.camera),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  Widget _background(BuildContext context, EditAccountState state) {
    final width = MediaQuery.of(context).size.width;

    final coverImage = state.coverImage;
    if (coverImage is LocalUserImage) {
      return Image.file(
        coverImage.image,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (coverImage is NetworkUserImage) {
      return Image.network(
        coverImage.url,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      width: width,
      height: height,
    );
  }
}
