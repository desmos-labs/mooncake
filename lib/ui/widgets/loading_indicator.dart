import 'package:flutter/material.dart';

/// Represents an indicator that tells the user that data is being loaded.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
