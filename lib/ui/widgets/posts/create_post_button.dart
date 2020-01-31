import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Represents the callback that is used to return the data of the created
/// post.
typedef OnSaveCallback = Function(Post post);

/// Represents the button that is clicked when the user wants to create
/// a new post after having inserted all the informations.
class CreatePostButton extends StatelessWidget {
  final OnSaveCallback callback;

  const CreatePostButton({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostInputBloc, PostInputState>(
        builder: (context, state) {
      return Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              key: PostsKeys.saveNewPost,
              child: Text(PostsLocalizations.of(context).createPost),
              onPressed:
                  !state.isValid ? null : () => _createPost(context, state),
            ),
          ),
        ],
      );
    });
  }

  void _createPost(BuildContext context, PostInputState state) async {
    // ignore: close_sinks
    final bloc = BlocProvider.of<PostInputBloc>(context);
    bloc.add(SavePost());

    final useCase = Injector.get<CreatePostUseCase>();
    final post = await useCase.create(
      message: state.message,
      parentId: null,
      allowsComments: state.allowsComments,
    );

    final saveUseCase = Injector.get<SavePostUseCase>();
    await saveUseCase.save(post);

    callback(post);
  }
}
