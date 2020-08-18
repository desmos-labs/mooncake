import 'package:flutter/material.dart';

/// Represents an indicator that tells the user that data is being loaded.
class LoadingIndicator extends StatelessWidget {
  final Color color;
  const LoadingIndicator({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
