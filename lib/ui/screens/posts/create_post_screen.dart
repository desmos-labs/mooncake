import 'package:desmosdemo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);

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
    // Create the comment
    // ignore:close_sinks
    final bloc = BlocProvider.of<PostsBloc>(context);
    bloc.add(AddPost(
      parentId: null,
      message: state.message,
    ));

    Navigator.pop(context);
  }
}
