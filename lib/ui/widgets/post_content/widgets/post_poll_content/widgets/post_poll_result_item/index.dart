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
  double percentage;
  int currentPollLength;
  BorderRadius borderRadiusResults;

  PostPollResultItem({
    Key key,
    @required this.poll,
    @required this.option,
  })  : currentPollLength = poll.userAnswers
            .where((answer) => answer.answer == option.id)
            .length,
        super(key: key) {
    percentage = currentPollLength / poll.userAnswers.length;
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
              horizontal: ThemeSpaces.mediumMargin,
              vertical: ThemeSpaces.smallMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '(${currentPollLength})',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                        ),
                      ),
                      TextSpan(
                        text: ' ${(percentage * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
