import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';

import 'poll_question_editor.dart';
import 'poll_option_editor.dart';
import 'poll_end_date_editor.dart';

/// Represents the serie of widgets that allow to create a poll for a post.
class PostPollCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostInputBloc, PostInputState>(
      builder: (context, state) {
        final optionsLength = state.poll?.options?.length ?? 0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PollQuestionEditor(),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: optionsLength,
              itemBuilder: (context, index) {
                return PollOptionEditor(option: state.poll.options[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
            ),
            const SizedBox(height: 4),
            if (optionsLength < 5)
              FlatButton(
                textColor: Theme.of(context).accentColor,
                child: Text(PostsLocalizations.of(context).pollAddOptionButton),
                onPressed: () => _addOption(context),
              ),
            const SizedBox(height: 4),
            PollEndDateEditor(),
          ],
        );
      },
    );
  }

  void _addOption(BuildContext context) {
    BlocProvider.of<PostInputBloc>(context).add(AddPollOption());
  }
}
