import 'package:flutter/material.dart';

/// Returns the decoration that is used on all poll input fields.
Decoration getInputDecoration(BuildContext context) {
  return BoxDecoration(
    border: Border.all(
      width: 2,
      color: Theme.of(context).primaryColorDark,
    ),
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );
}
