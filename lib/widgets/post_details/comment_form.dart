import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/localization.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Form that is used while creating a new comment to the given [post].
class CommentForm extends StatefulWidget {
  final Post post;

  const CommentForm({Key key, @required this.post}) : super(key: key);

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  TextEditingController _messageController = TextEditingController();

  CommentInputBloc _bloc;

  bool isCommentButtonEnabled(CommentInputState state) {
    return state.isMessageValid;
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _messageController.addListener(_onMessageChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentInputBloc, CommentInputState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  controller: _messageController,
                  key: PostsKeys.postMessageField,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: FlutterBlocLocalizations.of(context).newComment,
                  ),
                  autocorrect: false,
                ),
                FlatButton(
                  child: Text(FlutterBlocLocalizations.of(context).commentHint),
                  onPressed: !state.isMessageValid
                      ? null
                      : () => _onCommentClicked(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Called when the comment button has been clicked.
  void _onCommentClicked(BuildContext context) {
    // Create the comment
    // ignore:close_sinks
    final bloc = BlocProvider.of<PostCommentsBloc>(context);
    bloc.add(CreatePostComment(
      postId: widget.post.id,
      message: _messageController.text,
    ));

    // Reset the form and close the keyboard
    _messageController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Called when the message has changed.
  void _onMessageChanged() {
    _bloc.add(MessageChanged(_messageController.text));
  }
}
