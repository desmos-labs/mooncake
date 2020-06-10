import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';

/// Represents the screen that allows to display the details of a given [user].
class UserDetailsScreen extends StatelessWidget {
  final User user;

  const UserDetailsScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AccountViewBody(user: user),
    );
  }
}
