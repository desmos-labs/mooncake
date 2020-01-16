import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';

/// Represents the loader shown to the user while a new page of posts
/// is being fetched.
class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoadingIndicator(),
      ],
    );
  }
}
