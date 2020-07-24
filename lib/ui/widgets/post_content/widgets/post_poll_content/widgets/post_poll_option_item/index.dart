import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import '../../utils.dart' show pollColors;

/// Represents the single option that can be clicked by the user.
class PostPollOptionItem extends StatelessWidget {
  final Post post;
  final PollOption option;
  final int index;

  const PostPollOptionItem({
    Key key,
    @required this.post,
    @required this.option,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(10),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: pollColors[index % pollColors.length],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: pollColors[index % pollColors.length]),
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: () => _voteOption(context),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          option.text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _voteOption(BuildContext context) {
    BlocProvider.of<PostsListBloc>(context).add(VotePoll(post, option));
  }
}
