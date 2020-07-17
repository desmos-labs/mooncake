import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/theme/spaces.dart';

/// Represents a single row showing the percentage of voting that the
/// given poll option had.
class PostPollResultItem extends StatelessWidget {
  final PostPoll poll;
  final PollOption option;

  /// Represents the percentage of times that this option has
  /// been chosen over all the others.
  final double percentage;

  PostPollResultItem({
    Key key,
    @required this.poll,
    @required this.option,
  })  : percentage = (poll.userAnswers
                .where((answer) => answer.answer == option.id)
                .length) /
            poll.userAnswers.length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned.fill(
            child: Container(
              width: MediaQuery.of(context).size.width * percentage,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).accentColor.withOpacity(0.25),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeSpaces.smallMargin,
              vertical: ThemeSpaces.smallMargin,
            ),
            child: Row(
              children: [
                Text(
                  "${(percentage * 100).toInt()}%",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Text(option.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
