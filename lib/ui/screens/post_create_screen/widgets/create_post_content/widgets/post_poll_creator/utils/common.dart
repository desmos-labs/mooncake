import 'package:flutter/material.dart';

/// Returns the decoration that is used on all poll input fields.
Decoration getInputOutline(BuildContext context) {
  return BoxDecoration(
    border: Border.all(
      width: 0.5,
      color: Theme.of(context).colorScheme.onError,
    ),
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );
}

InputDecoration getInputDecoration(BuildContext context, String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Theme.of(context).colorScheme.onError,
    ),
    border: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  );
}
