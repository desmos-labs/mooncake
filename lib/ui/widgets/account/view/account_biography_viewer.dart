import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

class AccountBiographyViewer extends StatelessWidget {
  final User user;

  const AccountBiographyViewer({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              height: 2,
              width: 80,
              child: Container(color: Theme.of(context).primaryColorLight),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (user.bio != null) Text(user.bio),
      ],
    );
  }
}
