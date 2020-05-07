import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents a single row showing the percentage of voting that the
/// given poll option had.
class PostPollResultItem extends StatelessWidget {
  final Post post;
  final PollOption option;
  final double height;

  /// Represents the percentage of times that this option has
  /// been chosen over all the others.
  double percentage;

  PostPollResultItem({
    Key key,
    this.height,
    @required this.post,
    @required this.option,
  }) : super(key: key) {
    // Get the number of total answers
    final totalAnswers = post.pollAnswers
        .map((e) => e.answers.length)
        .reduce((value, element) => value + element);

    // Get the number of answers for this option
    final specificAnswers = post.pollAnswers
        .where((element) => element.answers.contains(option.id))
        .length;

    // Compute the percentage
    percentage = specificAnswers / totalAnswers * 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: height,
            width: MediaQuery.of(context).size.width * percentage,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).accentColor.withOpacity(0.25),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  "${percentage.toInt()}%",
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
