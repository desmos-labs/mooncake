import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';
import 'package:mooncake/ui/screens/post_create_screen/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

/// Screen that is shown to the user in order to allow him to input the
/// message of a new post.
/// When creating this screen, the [callback] parameter should be given. It
/// represents the method that must be called upon the click on the save button
/// inside the editor itself.
class CreatePostScreen extends StatelessWidget {
  final Post parentPost;
  final bottomBarHeight = 50.0;

  const CreatePostScreen({Key key, this.parentPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostInputBloc.create(context, parentPost),
      child: BlocBuilder<PostInputBloc, PostInputState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).cardColor,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  CreatePostContent(
                    parentPost: parentPost,
                    bottomPadding: bottomBarHeight,
                  ),
                  Positioned(
                    bottom: 0,
                    child: PostCreateActions(height: bottomBarHeight),
                  ),
                  if (state.showPopup)
                    GenericPopup(
                      content: PostSavingPopupContent(),
                      onTap: () {
                        BlocProvider.of<PostInputBloc>(context)
                            .add(HidePopup());
                      },
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
