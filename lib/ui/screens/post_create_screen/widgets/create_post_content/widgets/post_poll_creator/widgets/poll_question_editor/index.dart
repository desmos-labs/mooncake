import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';

import '../../utils/export.dart';

/// Represents the editor that should be used when changing the
/// question associated to a poll.
class PollQuestionEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: getInputOutline(context),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              decoration: getInputDecoration(
                context,
                PostsLocalizations.of(context)
                    .translate(Messages.pollQuestionHint),
              ),
              onChanged: (value) => _onChanged(context, value),
            )
          ],
        ),
      ),
    );
  }

  void _onChanged(BuildContext context, String value) {
    BlocProvider.of<PostInputBloc>(context).add(UpdatePollQuestion(value));
  }
}
