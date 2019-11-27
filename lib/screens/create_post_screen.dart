import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../keys.dart';
import '../localization.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _message;

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createPost),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: CommentForm(),
      ),
      floatingActionButton: FloatingActionButton(
        key: PostsKeys.saveNewPost,
        tooltip: localizations.createPost,
        child: Icon(Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();


            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
