import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

import 'post_poll_option_item.dart';

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
                if (!hasVoted)
                  ListView.builder(
                    itemCount: post.poll.options.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return PostPollOptionItem(
                        post: post,
                        option: post.poll.options[index],
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
