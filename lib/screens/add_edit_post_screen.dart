import 'package:flutter/material.dart';

import 'package:desmosdemo/models/models.dart';

import 'package:desmosdemo/keys.dart';

import '../keys.dart';
import '../localization.dart';

typedef OnSaveCallback = Function(String message);

class AddEditPostScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Post post;

  const AddEditPostScreen({
    Key key,
    @required this.isEditing,
    @required this.onSave,
    this.post,
  }) : super(key: key);

  @override
  _AddEditPostScreenState createState() => _AddEditPostScreenState();
}

class _AddEditPostScreenState extends State<AddEditPostScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _message;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? localizations.editPost : localizations.createPost,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? widget.post.message : '',
                key: PostsKeys.postMessageField,
                autofocus: !isEditing,
                style: textTheme.headline,
                decoration: InputDecoration(
                  hintText: localizations.newPostHint,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyPostError
                      : null;
                },
                onSaved: (value) => _message = value,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: isEditing ? PostsKeys.savePostFab : PostsKeys.saveNewPost,
        tooltip:
            isEditing ? localizations.saveChanges : localizations.createPost,
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.onSave(_message);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
