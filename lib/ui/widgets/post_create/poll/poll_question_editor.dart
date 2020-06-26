import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'common.dart';

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
              decoration: getInputDecoration(
                PostsLocalizations.of(context).pollQuestionHint,
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
