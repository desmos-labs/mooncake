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
  BorderRadius borderRadiusResults;

  PostPollResultItem({
    Key key,
    @required this.poll,
    @required this.option,
  })  : percentage = (poll.userAnswers
                .where((answer) => answer.answer == option.id)
                .length) /
            poll.userAnswers.length,
        super(key: key) {
    borderRadiusResults = percentage >= 0.95
        ? BorderRadius.circular(8)
        : BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              height: 35.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1.0, color: Colors.blue),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: percentage,
            child: Container(
              // width: MediaQuery.of(context).size.width * percentage,
              // width: MediaQuery.of(context).size.width * 0.60,
              height: 35.0,
              decoration: BoxDecoration(
                borderRadius: borderRadiusResults,
                // color: Theme.of(context).accentColor.withOpacity(0.25),
                color: Colors.blue,
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
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  option.text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
