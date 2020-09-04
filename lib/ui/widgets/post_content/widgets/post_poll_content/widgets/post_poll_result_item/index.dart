import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import '../../utils.dart' show pollColors;

/// Represents a single row showing the percentage of voting that the
/// given poll option had.
class PostPollResultItem extends StatelessWidget {
  final PostPoll poll;
  final PollOption option;
  final int index;
  final int currentPollLength;
  final bool votedOption;

  PostPollResultItem({
    Key key,
    @required this.poll,
    @required this.option,
    @required this.index,
    @required this.votedOption,
  })  : currentPollLength = poll.userAnswers
            .where((answer) => answer.answer == option.id)
            .length,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = currentPollLength / poll.userAnswers.length;
    final borderRadiusResults = percentage >= 0.95
        ? BorderRadius.circular(8)
        : BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          );
    final selectedColor = pollColors[index % pollColors.length];

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
                border: Border.all(width: 1.0, color: selectedColor),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: percentage <= 0.0 ? 0.0 : percentage,
            child: Container(
              height: 35.0,
              decoration: BoxDecoration(
                borderRadius: borderRadiusResults,
                color: selectedColor,
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
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          option.text,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      if (votedOption)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            MooncakeIcons.success,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    children: <TextSpan>[
                      if (votedOption)
                        TextSpan(
                          text: '(${currentPollLength})',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.onPrimary,
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
