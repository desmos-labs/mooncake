import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

class SingleAccountItem extends StatelessWidget {
  final MooncakeAccount user;
  final Function onTap;

  SingleAccountItem({this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
            onTap: () {
              onTap(context, user);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  AccountAvatar(user: user, size: 40),
                  SizedBox(width: 20),
                  Text(user.screenName, textAlign: TextAlign.end),
                ],
              ),
            )),
        color: Colors.transparent,
      ),
    );
  }
}
