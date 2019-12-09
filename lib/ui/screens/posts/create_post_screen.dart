import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnSaveCallback = Function(String parentId, String message);

class CreatePostScreen extends StatefulWidget {
  final OnSaveCallback callback;

  const CreatePostScreen({
    Key key,
    @required this.callback,
  }) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = PostsLocalizations.of(context);

    return BlocProvider(
      create: (context) => PostInputBloc.create(),
      child: BlocBuilder<PostInputBloc, PostInputState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(localizations.createPost),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: PostForm(),
            ),
            floatingActionButton: FloatingActionButton(
              key: PostsKeys.saveNewPost,
              tooltip: localizations.createPost,
              child: Icon(Icons.add),
              onPressed:
                  !state.isValid ? null : () => _createPost(context, state),
            ),
          );
        },
      ),
    );
  }

  void _createPost(BuildContext context, PostInputState state) {
    widget.callback(null, state.message);
    Navigator.pop(context);
  }
}
