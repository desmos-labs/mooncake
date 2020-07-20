import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the single option that can be clicked by the user.
class PostPollOptionItem extends StatelessWidget {
  final Post post;
  final PollOption option;

  const PostPollOptionItem({
    Key key,
    @required this.post,
    @required this.option,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: () => _voteOption(context),
      child: Text(option.text),
    );
  }

  void _voteOption(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(VotePoll(post, option));
  }
}
