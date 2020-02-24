import 'package:flutter/material.dart';
import 'package:mooncake/ui/theme/theme.dart';

class MoreButton extends StatelessWidget {
  final Function onTap;

  const MoreButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        "...",
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: PostsTheme.textColorLight,
            ),
      ),
    );
  }
}
