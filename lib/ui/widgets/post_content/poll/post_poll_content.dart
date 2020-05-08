import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_poll_option_item.dart';
import 'post_poll_result_item.dart';

/// Represents the widget used to show the details of a poll inside a post.
class PostPollContent extends StatelessWidget {
  static const double OPTION_HEIGHT = 30.0;
  static const double SEPARATOR_HEIGHT = OPTION_HEIGHT * 0.25;

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
        final hasVoted = post.hasVoted(account);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(post.poll.question, textAlign: TextAlign.center),
                const SizedBox(height: SEPARATOR_HEIGHT),
                if (!hasVoted)
                _buildListView((option) {
                  return PostPollOptionItem(
                    height: OPTION_HEIGHT,
                    post: post,
                    option: option,
                  );
                }),
                if (hasVoted)
                  _buildListView((option) {
                    return PostPollResultItem(
                      height: OPTION_HEIGHT,
                      poll: post.poll,
                      option: option,
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(Widget Function(PollOption option) builder) {
    return ListView.separated(
      itemCount: post.poll.options.length,
      itemBuilder: (context, index) {
        final option = post.poll.options[index];
        return builder(option);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: SEPARATOR_HEIGHT);
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}
