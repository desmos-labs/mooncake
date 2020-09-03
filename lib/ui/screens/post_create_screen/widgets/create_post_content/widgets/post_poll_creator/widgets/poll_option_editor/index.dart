import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';

import '../../utils/export.dart';

/// Allows to edit the text of a poll option, edit the associated image (or
/// add a new one) or delete the option entirely.
class PollOptionEditor extends StatefulWidget {
  final PollOption option;
  const PollOptionEditor({Key key, this.option}) : super(key: key);

  @override
  _PollOptionEditorState createState() => _PollOptionEditorState();
}

class _PollOptionEditorState extends State<PollOptionEditor> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final hintText =
        '${PostsLocalizations.of(context).translate(Messages.pollOptionHint)} ${widget.option.id + 1}';

    if (widget.option.text != _textEditingController.text) {
      _textEditingController.text = widget.option.text;
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: getInputOutline(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(context, hintText),
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) =>
                                _onTextChanged(context, value),
                          ),
                        ),
                        // TODO: Implement the association of an image to a poll option
                        // IconButton(
                        //   icon: const Icon(MooncakeIcons.picture),
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                  ),
                ),
                if (widget.option.id > 1)
                  Container(
                    child: IconButton(
                      icon: const Icon(MooncakeIcons.delete),
                      tooltip: PostsLocalizations.of(context)
                          .translate(Messages.pollDeleteOptionHint),
                      onPressed: () => _deleteOption(context),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 0.5,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onTextChanged(BuildContext context, String value) {
    BlocProvider.of<PostInputBloc>(context)
        .add(UpdatePollOption(widget.option.id, value));
  }

  void _deleteOption(BuildContext context) {
    BlocProvider.of<PostInputBloc>(context)
        .add(DeletePollOption(widget.option.id));
  }
}
