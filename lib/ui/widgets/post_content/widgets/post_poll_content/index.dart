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
        final hasVoted = _hasVoted(post.poll, account.address);

        return Container(
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.poll.question.isNotEmpty) Text(post.poll.question),
                if (hasVoted == null)
                  _buildListView((option, index) {
                    return PostPollOptionItem(
                      post: post,
                      option: option,
                      index: index,
                    );
                  }),
                if (hasVoted != null)
                  _buildListView((option, index) {
                    return PostPollResultItem(
                      poll: post.poll,
                      option: option,
                      index: index,
                      votedOption: hasVoted == index,
                    );
                  }),
                if (hasVoted != null) _votesAndEnding(context)
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
              '${post.poll.userAnswers.length} ${PostsLocalizations.of(context).translate(Messages.votes)}',
            ),
            const SizedBox(width: 4),
            const Text('•'),
            const SizedBox(width: 4),
            if (post.poll.isOpen)
              Text(
                '${PostsLocalizations.of(context).translate(Messages.pollEndOn)} ${date}',
              ),
            if (!post.poll.isOpen)
              Text(PostsLocalizations.of(context)
                  .translate(Messages.finalResults)),
          ],
        ),
      ],
    );
  }

  Widget _buildListView(Widget Function(PollOption option, int index) builder) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 15, bottom: 10),
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

  /// Tells whether this [MooncakeAccount] has voted on the given [poll] or not.
  int _hasVoted(PostPoll poll, String address) {
    var option = poll.userAnswers
        .where((answer) => answer.user.address == address)
        .toList();

    return option.isNotEmpty ? option[0].answer : null;
  }
}
