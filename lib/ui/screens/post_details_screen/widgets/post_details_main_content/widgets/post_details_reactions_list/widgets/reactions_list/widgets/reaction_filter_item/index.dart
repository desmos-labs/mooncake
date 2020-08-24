import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/spaces.dart';

class ReactionFilterItem extends StatelessWidget {
  final String value;
  final String display;
  final String active;
  final Function onClick;

  const ReactionFilterItem({
    Key key,
    @required this.value,
    @required this.display,
    @required this.active,
    @required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == active;
    final Color color = isSelected
        ? Theme.of(context).colorScheme.primaryVariant
        : Colors.grey[100];
    final Color textColor = isSelected ? Colors.white : Colors.black;
    return InkWell(
      onTap: () => onClick(value),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        padding: EdgeInsets.symmetric(
            vertical: ThemeSpaces.smallGutter, horizontal: 15),
        alignment: Alignment.center,
        child: Text(
          display,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
