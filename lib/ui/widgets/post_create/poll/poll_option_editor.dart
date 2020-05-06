import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'common.dart';

/// Allows to edit the text of a poll option, edit the associated image (or
/// add a new one) or delete the option entirely.
class PollOptionEditor extends StatelessWidget {
  final PollOption option;
  const PollOptionEditor({Key key, this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hintText =
        "${PostsLocalizations.of(context).pollOptionHint} ${option.id + 1}";

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: getInputDecoration(context),
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: hintText),
                    onChanged: (value) => _onTextChanged(context, value),
                  ),
                ),
// TODO: Implement the association of an image to a poll option
//                IconButton(
//                  icon: Icon(MooncakeIcons.picture),
//                  onPressed: () {},
//                ),
                if (option.id > 1)
                  IconButton(
                    icon: Icon(MooncakeIcons.delete),
                    tooltip:
                        PostsLocalizations.of(context).pollDeleteOptionHint,
                    onPressed: () => _deleteOption(context),
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
        .add(UpdatePollOption(option.id, value));
  }

  void _deleteOption(BuildContext context) {
    BlocProvider.of<PostInputBloc>(context).add(DeletePollOption(option.id));
  }
}
