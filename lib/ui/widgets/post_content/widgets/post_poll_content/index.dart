import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Represents the widget used to show the details of a poll inside a post.
class PostPollContent extends StatelessWidget {
  final Post post;

  const PostPollContent({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final account = (state as LoggedIn).user;
        final hasVoted = account.hasVoted(post.poll);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.poll.question, textAlign: TextAlign.center),
                if (!hasVoted)
                  _buildListView((option, index) {
                    return PostPollOptionItem(
                      post: post,
                      option: option,
                      index: index,
                    );
                  }),
                if (hasVoted)
                  _buildListView((option, index) {
                    return PostPollResultItem(
                      poll: post.poll,
                      option: option,
                      index: index,
                    );
                  }),
                if (hasVoted) _votesAndEnding(context)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _votesAndEnding(BuildContext context) {
    final formatter = DateFormat.MMMd().add_jm();
    final date = formatter.format(post.poll.endDateTime);

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              PostsLocalizations.of(context)
                  .votes(post.poll.userAnswers.length),
            ),
            const SizedBox(width: 4),
            const Text("•"),
            const SizedBox(width: 4),
            if (post.poll.isOpen)
              Text(PostsLocalizations.of(context).pollEndOn(date)),
            if (!post.poll.isOpen)
              Text(PostsLocalizations.of(context).finalResults),
          ],
        ),
      ],
    );
  }

  Widget _buildListView(Widget Function(PollOption option, int index) builder) {
    return ListView.separated(
      itemCount: post.poll.options.length,
      itemBuilder: (context, index) {
        final option = post.poll.options[index];
        return builder(option, index);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: ThemeSpaces.smallGutter);
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
