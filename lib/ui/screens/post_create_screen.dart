import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Screen that is shown to the user in order to allow him to input the
/// message of a new post.
/// When creating this screen, the [callback] parameter should be given. It
/// represents the method that must be called upon the click on the save button
/// inside the editor itself.
class CreatePostScreen extends StatelessWidget {
  final bottomBarHeight = 50.0;

  const CreatePostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostInputBloc.create(),
      child: BlocBuilder<PostInputBloc, PostInputState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                CreatePostContent(bottomPadding: bottomBarHeight),
                Positioned(
                  bottom: 0,
                  child: PostCreateActions(height: bottomBarHeight),
                ),
                if (state.saving)
                  GenericPopup(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    content: PostSavingPopupContent(),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
