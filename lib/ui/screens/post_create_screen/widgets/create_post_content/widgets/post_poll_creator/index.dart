import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';
import 'widgets/export.dart';

/// Represents the serie of widgets that allow to create a poll for a post.
class PostPollCreator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostInputBloc, PostInputState>(
      builder: (context, state) {
        final optionsLength = state.poll?.options?.length ?? 0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            if (optionsLength < 5)
              FlatButton(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                textColor: Theme.of(context).colorScheme.primary,
                child: Text(PostsLocalizations.of(context)
                    .translate(Messages.pollAddOptionButton)),
                onPressed: () => _addOption(context),
              ),
            SizedBox(height: optionsLength < 5 ? 10 : 30),
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
